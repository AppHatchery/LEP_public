//
//  TranslateViewController.swift
//  LEP
//
//  Created by Yago Arconada on 10/21/23.
//

import UIKit
import Foundation
import MicrosoftCognitiveServicesSpeech
import AVFoundation
import Pendo

class TranslateViewController: UIViewController, UITextViewDelegate, PlaybackServiceDelegate {
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var speakerIcon: UIButton!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var timerIcon: UIImageView!
    @IBOutlet weak var outputText: UILabel!
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var errorMessageHeightConstraint: NSLayoutConstraint!
    
    let tap = UITapGestureRecognizer()
    let playback = PlaybackService()
    
    var audioPlayer: AVAudioPlayer?
    
    var selectedLanguage = "en-US"
    var inputLanguage = "en"
    var targetLanguage = "es"
    var transcribedText = ""
    var placeholderText = "Speak now..."
    
    var countdownSeconds = 10 // The duration of the countdown in seconds
    var timeRestriction: CGFloat = 11.0
    var timer: Timer?
    var circleLayer: CAShapeLayer?
    var timeText = "Please limit the recording to 10 seconds"
    var timeoutText = "Timeout, please avoid lengthy sentences"
    var stopRecording = false
    let minFont = 12
    
    var reco: SPXTranslationRecognizer? // SPXSpeechRecognizer? for only recognizing speech
    var requestResult: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        requestMicrophonePermission()
        // I have to wire the request for Speech-To-Text here
        inputText.delegate = self
        requestButton.setImage(UIImage(named: "Stop"), for: .normal)
        // Keyboard dismissal recognizer
        tap.addTarget(self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // If target language is English edit the view
        if targetLanguage == "en" {
            speakerIcon.isHidden = true
        }
        
        updateLabels(for: inputLanguage, timeAvailable: 10)
                
        // Closures
        playback.onSpeakRange = { [weak self] range, string in
            self?.highlightSpokenWord(range: range, inString: string)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        inputText.text = placeholderText

        playback.playSound(named: "listen_start")
        timeStart()
        callRequest()
    }
    
    func getTranslation(for key: String, languageCode: String, countdownSeconds: Int? = nil) -> String {
        if let languageTranslations = TranslationLabelsManager.shared.realTimeTranslationInstructions[languageCode],
           let translation = languageTranslations[key] {
            return translation
        }
        return TranslationLabelsManager.shared.realTimeTranslationInstructions["en"]?[key] ?? "Translation not available"
    }
    
    func updateLabels(for languageCode: String, timeAvailable: Int) {
        if languageCode == "en" {
            speakerIcon.isHidden = true
        } else {
            speakerIcon.isHidden = false
        }

        timeText = getTranslation(for: "timeText", languageCode: languageCode, countdownSeconds: timeAvailable)
        timerText.text = timeText
        timeoutText = getTranslation(for: "timeoutText", languageCode: languageCode)
        placeholderText = getTranslation(for: "placeholderText", languageCode: languageCode)
    }
    
    func displayTranslatedText(translatedText: String, requestedText: String){
        DispatchQueue.main.async {
            // Update your UI element here
            self.outputText.text = translatedText
            self.requestButton.setImage(UIImage(named: "Record"), for: .normal)
            self.outputView.isHidden = false
//            self.timerView.isHidden = true
            // This if statement prevents the voice from speaking out loud for the English phrase, should be removed to make system speak dynamically on either language
            if self.targetLanguage == Model().translateLanguages[0] {
                self.playback.delegate = self
                self.loadAudio(language: "en")
            } else {
                self.playback.delegate = self
                self.loadAudio()
                // Speech Synthesis using Azure
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { // Add a slight delay to ensure UI updates are visible
//                    // Speech Synthesis using Azure
//                    self.textToSpeechCall(writtenText: translatedText)
//                }
//                self.textToSpeechCall(writtenText: translatedText)
            }
            // Remove the error message from the view to increase display space
            self.errorMessageHeightConstraint.constant = 0
            PendoManager.shared().track("Translate", properties: [self.inputLanguage:requestedText,self.targetLanguage:translatedText,"inputLanguage":self.inputLanguage])
        }
    }
    
    func textToSpeechCall(writtenText: String){
        var speechConfig: SPXSpeechConfiguration?
        do {
            try speechConfig = SPXSpeechConfiguration(subscription: "YOUR-SUBSCRIPTION-KEY", region: "eastus")
        } catch {
            print("error \(error) happened")
            speechConfig = nil
        }

        // Mapping language codes to Azure Neural Voice names
        let voiceMap: [String: String] = [
            "am": "am-ET-MekdesNeural",      // Amharic
            "ar": "ar-SA-HamedNeural",       // Arabic
            "my": "my-MM-NilarNeural",         // Burmese
            "fr": "fr-FR-DeniseNeural",      // French
            "ko": "ko-KR-InJoonNeural",      // Korean
            "zh": "zh-CN-XiaohanNeura",    // Mandarin
            "pt": "pt-BR-AntonioNeural",     // Portuguese
            "es": "es-MX-BeatrizNeural",      // Spanish
            "vi": "vi-VN-NamMinhNeural"      // Vietnamese
        ]
        
        // Extract the language code from the source language
        let languageCode = String(targetLanguage.prefix(2))
        
        // Select the appropriate voice or default to a generic voice
        speechConfig?.speechSynthesisVoiceName = voiceMap[languageCode] ?? "en-US-AriaNeural"

        let synthesizer = try! SPXSpeechSynthesizer(speechConfig!)
        let result = try! synthesizer.speakText(writtenText)
        if result.reason == SPXResultReason.canceled
        {
            let cancellationDetails = try! SPXSpeechSynthesisCancellationDetails(fromCanceledSynthesisResult: result)
            print("cancelled, error code: \(cancellationDetails.errorCode) detail: \(cancellationDetails.errorDetails!) ")
            print("Did you set the speech resource key and region values?");
            return
        }
    }
    
    func translateText(requestedText: String){
        makeRequest(requestText: requestedText, inputLanguage: inputLanguage, targetLanguage: targetLanguage) { result in
            switch result {
            case .success(let translatedText):
                DispatchQueue.main.async {
                    // Update your UI element here
                    self.outputText.text = translatedText
                    self.requestButton.setImage(UIImage(named: "Record"), for: .normal)
                    self.outputView.isHidden = false
                    self.timerView.isHidden = true
                    if self.targetLanguage == Model().translateLanguages[1] {
                        self.playback.delegate = self
                        self.loadAudio()
                    }
                    PendoManager.shared().track("Translate", properties: [self.inputLanguage:requestedText,self.targetLanguage:translatedText])
                }
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.requestButton.setImage(UIImage(named: "Record"), for: .normal)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        do {
            try reco?.stopContinuousRecognition()
            reco = nil
        } catch {
            print("Error cleaning up recognition in deinit: \(error)")
        }
    }
    
    func requestMicrophonePermission() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                // Microphone access granted
                // You can now use the microphone
            } else {
                // Microphone access denied
                // Handle the case where access is denied
            }
        }
    }
    
    func speechToText(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let translationConfig = try SPXSpeechTranslationConfiguration(subscription: "YOUR-SUBSCRIPTION-KEY", region: "eastus")
                translationConfig.speechRecognitionLanguage = self.selectedLanguage
                translationConfig.addTargetLanguage(self.targetLanguage)

                let audioConfig = SPXAudioConfiguration()
                self.reco = try SPXTranslationRecognizer(speechTranslationConfiguration: translationConfig, audioConfiguration: audioConfig)

                self.reco!.addRecognizingEventHandler() { _, evt in
                    let intermediateText = evt.result.text ?? "..."
                    print("Intermediate recognition: \(intermediateText)")
                    self.updateLabel(text: intermediateText, color: .gray)
                }

                print("Speak into your microphone.")
                let result = try self.reco!.recognizeOnce()

                self.requestResult = result.text ?? "no result"
                print("Recognition result: \(self.requestResult), reason: \(result.reason.rawValue)")
                self.updateLabel(text: self.requestResult, color: .nurseBlueColor)

                if result.reason != SPXResultReason.recognizedSpeech {
                    do {
                        let cancellationDetails = try SPXCancellationDetails(fromCanceledRecognitionResult: result)
                        print("Error code: \(cancellationDetails.errorCode)")
                        print("Error reason: \(cancellationDetails.reason)")
                    } catch {
                        print("Error getting cancellation details: \(error)")
                    }

                    if let translation = result.translations[self.targetLanguage] {
                        print("Translated: \(translation)")
                        self.displayTranslatedText(translatedText: translation as! String, requestedText: self.requestResult)
                    }
                }

                // Completion after processing
                DispatchQueue.main.async {
                    completion()
                }

            } catch {
                print("Error during speech recognition: \(error)")
                self.playback.playSound(named: "listen_end")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

    func updateLabel(text: String?, color: UIColor) {
        DispatchQueue.main.async {
            self.inputText.text = text!
            self.inputText.textColor = color
            self.transcribedText = text!
            self.inputText.adjustFontSize(minimumFont: 14.0)
        }
    }
    
    @IBAction func requestTranslation(_ sender: UIButton){
        dismissKeyboard()
        if sender.currentImage == UIImage(named: "Record"){
            // Go back to the previous screen
            /*
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }*/
            // Refresh the view to keep going
            playback.playSound(named: "listen_start")
            refreshView()
            callRequest()
        } else {
            // Reset the View
            sender.setImage(UIImage(named: "Record"), for: .normal)
            timeStop()
            // TODO: request should be cancelled if user manually stops the recording
            do {
                guard let reco = reco else {
                    print("Recognition object is nil.")
                    return
                }

                try reco.stopContinuousRecognition()

                print("transcribed", self.transcribedText)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Add a slight delay if needed
                    print("transcribed", self.transcribedText)
                    print("request result", self.requestResult)
                    self.translateText(requestedText: self.requestResult)
                }
            } catch {
                print("Error stopping continuous recognition: \(error.localizedDescription)")
            }
            self.timerView.isHidden = true
//            self.inputText.text = ""
//            self.outputView.isHidden = true
        }
    }
    
    func refreshView(){
        stopAudio()
        timeStop()
        timeStart()
        inputText.font = UIFont.gothamRoundMedium40
        requestButton.setImage(UIImage(named: "Stop"), for: .normal)
        outputView.isHidden = true
        timerView.isHidden = false
        inputText.text = placeholderText
        inputText.isHidden = false
    }
    
    func callRequest(){
        DispatchQueue.global(qos: .userInitiated).async {
            self.speechToText {
                DispatchQueue.main.async {
                    // Ensure timeStop runs on the main thread
                    print("speech detection request finished")
                    self.timeStop()
                }
            }
//            if stopRecording {
//                self.translateText(requestedText: self.transcribedText)
//                stopRecording = true
//            }
//            self.translateText(requestedText: self.transcribedText)
        }
    }
    
    func highlightSpokenWord(range: NSRange, inString string: String) {
        print(self.outputText)
        guard let label = self.outputText else {
            print("label not found")
            return
        }

        let attributedString = NSMutableAttributedString(string: string)
        
        // Apply black background color to the spoken word
        attributedString.addAttribute(.foregroundColor, value: label.textColor.withAlphaComponent(0.8), range: range)

        // Update your label with the highlighted text
        DispatchQueue.main.async {
            label.attributedText = attributedString
        }
    }
    
    
    @IBAction func speakerTapped() {
        // Move delegate to the interaction so that it detects when user presses
        playback.delegate = self
        loadAudio()
    }
    
    func loadAudio(language: String? = nil) {
        playback.content = outputText.text
        if playback.isPlaying {
            stopAudio()
        } else {
            playAudio(language: language)
        }
    }

    private func playAudio(language: String? = nil) {
        playback.play(language: language)
        speakerIcon.setImage(UIImage(named: "speaker_mute"), for: .normal)
    }

    private func stopAudio() {
        playback.stop()
        speakerIcon.setImage(UIImage(named: "speaker_default"), for: .normal)
    }
    
//    func loadAudio(){
//        playback.content = outputText.text
//        if playback.isPlaying {
//            stopAudio()
//        } else {
//            playAudio()
//        }
//    }
//    
//    func loadEnglishAudio(){
//        playback.content = outputText.text
//        if playback.isPlaying {
//            stopAudio()
//        } else {
//            playback.playEnglish()
//            speakerIcon .setImage(UIImage(named: "speaker_mute"), for: .normal)
//        }
//    }
//    
//    private func playAudio() {
//        playback.play()
//        speakerIcon .setImage(UIImage(named: "speaker_mute"), for: .normal)
//    }
//    
//    private func stopAudio() {
//        playback.stop()
//        speakerIcon.setImage(UIImage(named: "speaker_default"), for: .normal)
//    }
    
    func didFinishPlaying(_ service: PlaybackService?) {
        stopAudio()
        // Wait for 2 seconds before refreshing the view
        DispatchQueue.main.asyncAfter (deadline: .now() + 2.0){
            self.outputText.textColor = UIColor.white.withAlphaComponent(1.0)
            self.refreshView()
            self.callRequest()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
        // Stop the recognition when user pops the view
        do {
            try reco?.stopContinuousRecognition()
            reco = nil
        } catch {
            print("Error stopping recognition when view is disappearing: \(error)")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        inputText.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        dismissKeyboard()
    }

    @objc func dismissKeyboard() {
        // To hide the keyboard when the user taps the screen
//        tap.isEnabled = false
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //        print("in Show")
        guard let userInfo = notification.userInfo else { return }
        
        
        // In iOS 16.1 and later, the keyboard notification object is the screen the keyboard appears on.
        guard let screen = notification.object as? UIScreen,
              // Get the keyboard’s frame at the end of its animation.
              let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        
        // Use that screen to get the coordinate space to convert from.
        let fromCoordinateSpace = screen.coordinateSpace
        
        
        // Get your view's coordinate space.
        let toCoordinateSpace: UICoordinateSpace = view
        
        
        // Convert the keyboard's frame from the screen's coordinate space to your view's coordinate space.
        let convertedKeyboardFrameEnd = fromCoordinateSpace.convert(keyboardFrameEnd, to: toCoordinateSpace)
        
        // Get the safe area insets when the keyboard is offscreen.
        var bottomOffset = view.safeAreaInsets.bottom
        
        // Get the intersection between the keyboard's frame and the view's bounds to work with the
        // part of the keyboard that overlaps your view.
        let viewIntersection = view.bounds.intersection(convertedKeyboardFrameEnd)
        
        // Check whether the keyboard intersects your view before adjusting your offset.
        if !viewIntersection.isEmpty {
            
            // Adjust the offset by the difference between the view's height and the height of the
            // intersection rectangle.
            bottomOffset = view.bounds.maxY - viewIntersection.minY
        }
        
        
        // The jitter before was caused by having a contentView inside the main view that was moving instead of the view itself 022423
        // Use the new offset to adjust your UI, for example by changing a layout guide, offsetting
        // your view, changing a scroll inset, and so on. This example uses the new offset to update
        // the value of an existing Auto Layout constraint on the view.
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= bottomOffset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        view.frame.origin.y = 0
    }

    func animateCircleFill(inView view: UIView, duration: TimeInterval) {
        view.layoutIfNeeded() // Ensure layout is updated
        // Create a circular path
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.bounds.midX,
                                                         y: view.bounds.midY - 20),
                                      radius: 20,
                                      startAngle: -CGFloat.pi / 2,
                                      endAngle: 3 * CGFloat.pi / 2,
                                      clockwise: true)
        
        // Create a CAShapeLayer and set its properties
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.nurseBlueColor.cgColor
        circleLayer.lineWidth = 2.0
        circleLayer.fillColor = UIColor.clear.cgColor

        // Save the circle layer
        self.circleLayer = circleLayer

        // Add the CAShapeLayer to the view's layer
        view.layer.addSublayer(circleLayer)

        // Animate the stroke end
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Add the animation
        circleLayer.add(animation, forKey: "fillCircle")
    }

    func stopCircleAnimation() {
        guard let circleLayer = self.circleLayer else {
            print("No circle layer to stop")
            return
        }
        
        print("Stopping circle animation")
        circleLayer.removeAllAnimations()
        circleLayer.removeFromSuperlayer()
        self.circleLayer = nil
        print("Circle animation stopped and layer removed")
    }

    
    func timeFinish(){
        timerView.backgroundColor = UIColor.timerEnd
        timerText.text = timeoutText
        timerText.textColor = UIColor.red
        timerIcon.isHidden = false
        
        requestButton.setImage(UIImage(named: "Record"), for: .normal)
        stopCircleAnimation()
        
        timer?.invalidate()
        timer = nil
        
        // Stop the continuous recognition after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.playback.playSound(named: "listen_end")
            do {
                try self?.reco?.stopContinuousRecognition()
            } catch {
                print("Error stopping recognition: \(error)")
            }
        }
    }
    
    func timeStart(){
        countDown()
        errorMessageHeightConstraint.constant = 112
        animateCircleFill(inView: timerView, duration: timeRestriction - 0.4)
        
        timerView.backgroundColor = UIColor.timerStart
        timerText.text = timeText
        timerText.textColor = UIColor.nurseBlueColor
        timerIcon.isHidden = true
    }
    
    func timeStop() {
        // Ensure timer is fully stopped and nil
        timer?.invalidate()
        timer = nil
        
        // Stop the circle animation
        stopCircleAnimation()
        
        // Reset UI elements
        timerView.backgroundColor = .clear
        timerText.text = ""
        timerIcon.isHidden = true
        
        // Reset countdown seconds
        countdownSeconds = 10
    }

    func countDown() {
        // Ensure any existing timer is stopped first
        timer?.invalidate()
        
        // Reset countdown
        countdownSeconds = 10
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.countdownSeconds -= 1
            
            if self.countdownSeconds <= 0 {
                timer.invalidate()
                self.timeFinish()
            }
        }
    }
}
