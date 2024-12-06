//
//  FrequentCard.swift
//  LEP
//
//  Created by Yago Arconada on 10/4/23.
//

import UIKit
import Foundation
import Pendo
import MicrosoftCognitiveServicesSpeech


class FrequentCard: UITableViewCell, PlaybackServiceDelegate {

    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var speakerIcon: UIButton!
    var translatedText: String = ""
    var englishText: String = ""
    
    let playback = PlaybackService()
    private var isManuallyStopped = false
    private var isPlaying = false
    
    weak var delegate: FrequentCardDelegate?
    
    let colorMapping: [UIColor: (backgroundColor: UIColor, titleColor: UIColor, borderColor: UIColor)] = [
        .patientGreenColor: (.secondaryGreenColor, .patientGreenColor, .patientGreenColor),
        .nurseBlueColor: (.secondaryBlueColor, .secondaryBlueColor, .secondaryBlueColor)
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(speakerTapped))
//        speakerIcon.addGestureRecognizer(tapGesture)
//        tapGesture.cancelsTouchesInView = false
//        configureView()
        englishButton.layer.borderWidth = 1.0
        englishButton.layer.cornerRadius = 8
        englishButton.titleLabel?.font = UIFont.gothamRoundBold18
    }
    
    func configureView() {
//        background.layer.masksToBounds = false
//        background.layer.shadowOpacity = 0.23
//        background.layer.shadowRadius = 4
//        background.layer.shadowOffset = CGSize(width: 0, height: 0)
//        background.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func speakerTapped(_ sender: UIButton) {
        // Ensuring the delegate is set
        playback.delegate = self
        playback.content = translatedText
        
        if isPlaying {
            muteAudio()
            PendoManager.shared().track("FrequentCard", properties: ["card": englishText, "audio": "mute", "locale": LanguageManager.shared.currentLanguageCode])
        } else {
            playAudio()
            PendoManager.shared().track("FrequentCard", properties: ["card": englishText, "audio": "play", "locale": LanguageManager.shared.currentLanguageCode])
            // Call delegate for when the cell is tapped only to play audio since we are using this delegate
            delegate?.cellWillPlay(in: self, withContent: englishText)
        }
    }

    // Implementing the delegate method correctly to detect when audio finishes playing
    func didFinishPlaying(_ service: PlaybackService?) {
        if !isManuallyStopped {
            stopAudio()
        }
        isManuallyStopped = false
    }

    private func playAudio() {
        isManuallyStopped = false
        playback.play()
        isPlaying = true
        updateButtonForPlayingState(isPlaying: isPlaying)
    }

    private func stopAudio() {
        playback.stop()
//        updateButtonForPlayingState(isPlaying: false)
    }

    private func muteAudio() {
        isManuallyStopped = true
        playback.stop()
        isPlaying = false
        updateButtonForPlayingState(isPlaying: isPlaying)
    }

    private func updateButtonForPlayingState(isPlaying: Bool) {
        let originalColor = englishButton.backgroundColor
        if isPlaying {
            englishButton.setTitle(translatedText, for: .normal)
            englishButton.backgroundColor = originalColor?.withAlphaComponent(1.0)
            englishButton.setTitleColor(UIColor.white, for: .normal)
            speakerIcon.tintColor = UIColor.white
        } else {
            englishButton.setTitle(englishText, for: .normal)
            englishButton.backgroundColor = originalColor?.withAlphaComponent(0)
            englishButton.setTitleColor(originalColor, for: .normal)
            speakerIcon.tintColor = originalColor
        }
        dropShadow()
    }
    
    func textToSpeechCall(writtenText: String){
        var speechConfig: SPXSpeechConfiguration?
        do {
            try speechConfig = SPXSpeechConfiguration(subscription: "YOUR-SUBSCRIPTION-KEY", region: "eastus")
        } catch {
            print("error \(error) happened")
            speechConfig = nil
        }
        
        speechConfig?.speechSynthesisVoiceName = "vi-VN-NamMinhNeural"
        
        let synthesizer = try! SPXSpeechSynthesizer(speechConfig!)
        synthesizer.addSynthesisCompletedEventHandler { synthesizer, _ in
            print("audio finished")
            DispatchQueue.main.async {
                self.stopAudio()
            }
        }
        let result = try! synthesizer.speakText(writtenText)
        if result.reason == SPXResultReason.canceled
        {
            let cancellationDetails = try! SPXSpeechSynthesisCancellationDetails(fromCanceledSynthesisResult: result)
            print("cancelled, error code: \(cancellationDetails.errorCode) detail: \(cancellationDetails.errorDetails!) ")
            print("Did you set the speech resource key and region values?");
            return
        }
    }
}

protocol FrequentCardDelegate: AnyObject {
    func cellWillPlay(in cell: FrequentCard, withContent englishContent: String)
}

