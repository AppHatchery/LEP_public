//
//  EditCardViewController.swift
//  LEP
//
//  Created by Yago Arconada on 10/22/23.
//

import UIKit
import Foundation

class EditCardViewController: UIViewController, UITextViewDelegate, PlaybackServiceDelegate {
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var speakerIcon: UIButton!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var outputText: UILabel!
    @IBOutlet weak var characterCount: UILabel?
    @IBOutlet weak var characterMaxWarning: UILabel?
    
    let tap = UITapGestureRecognizer()
    let playback = PlaybackService()
    
    var requestedText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        inputText.layer.borderWidth = 1
        inputText.layer.borderColor = UIColor.systemGray3.cgColor
        inputText.layer.cornerRadius = 8
        inputText.delegate = self
        
        inputText.textContainer.maximumNumberOfLines = 3 // Set this to your desired maximum number of lines
        inputText.textContainer.lineBreakMode = .byTruncatingTail
        // Keyboard dismissal recognizer
        tap.addTarget(self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func requestTranslation(_ sender: UIButton){
        dismissKeyboard()
        requestedText = inputText.text
        makeRequest(requestText: requestedText, inputLanguage: "en", targetLanguage: "es") { result in
            switch result {
            case .success(let translatedText):
                DispatchQueue.main.async {
                    // Update your UI element here
                    self.outputText.text = translatedText
                    self.outputText.textColor = UIColor.nurseBlueColor
                    self.playback.delegate = self
                    self.loadAudio()
                    
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func speakerTapped() {
        // Move delegate to the interaction so that it detects when user presses
        playback.delegate = self
        loadAudio()
    }
    
    func loadAudio(){
        playback.content = outputText.text
        if playback.isPlaying {
            stopAudio()
        } else {
            playAudio()
        }
    }
    
    private func playAudio() {
        playback.play()
        speakerIcon .setImage(UIImage(named: "speaker_mute"), for: .normal)
    }
    
    private func stopAudio() {
        playback.stop()
        speakerIcon.setImage(UIImage(named: "speaker_default"), for: .normal)
    }
    
    func didFinishPlaying(_ service: PlaybackService?) {
        stopAudio()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        dismissKeyboard()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.adjustFontSize(minimumFont: 16.0)
    }
    
    func calculateFontSize(for text: String, in textView: UITextView, minimumFont: CGFloat) -> CGFloat {
        let fontSize = textView.font?.pointSize ?? minimumFont
       while fontSize > minimumFont {
           let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: textView.frame.size.height))
           if size.height <= textView.frame.size.height {
               return fontSize
           } else {
               return fontSize - 1
           }
       }
       return minimumFont
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            inputText.resignFirstResponder()
            return false
        }
        // Update character count
        let newText = (inputText.text as NSString).replacingCharacters(in: range, with: text)
        characterCount?.text = "\(newText.count)/55"
        
        // Check if the character limit is exceeded
        if newText.count >= 55 {
            characterMaxWarning?.isHidden = false
            characterCount?.textColor = UIColor.red
            return false  // Prevent further input
        } else {
            characterMaxWarning?.isHidden = true
            characterCount?.textColor = UIColor.systemGray3
            return true
        }
    }
    
    @IBAction func clearField(_ sender: UIButton){
        inputText.text = ""
        inputText.font = UIFont.gothamRoundBold24
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
