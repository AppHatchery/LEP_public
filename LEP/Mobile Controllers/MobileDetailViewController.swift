//
//  MobileDetailViewController.swift
//  LEP
//
//  Created by Yago Arconada on 9/29/23.
//

import UIKit
import Pendo

class MobileDetailViewController: UIViewController, PlaybackServiceDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var spanishLabel: UILabel!
    @IBOutlet weak var speaker: UIButton!
    @IBOutlet weak var understand: UIButton!
    
    let playback = PlaybackService()
    var shouldHighlightUtterance = false
    private var understandIsPlaying = false
    
    var spanishTitle: String = ""
    var englishTitle: String = ""
    var imageTitle: String?
    var card: NurseCard?
    
    var understoodLabel: String = "¿Me ha entendido?"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playback.delegate = self
        
        image.image = UIImage(named: imageTitle ?? "")
        spanishLabel.text = spanishTitle
        englishLabel.text = englishTitle
        
        // Closures
        playback.onSpeakRange = { [weak self] range, string in
            self?.highlightSpokenWord(range: range, inString: string)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageDidChange, object: nil)
        
        PendoManager.shared().track("Cards", properties: ["card": englishTitle, "locale": LanguageManager.shared.currentLanguageCode])

        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func languageChanged(notification: Notification) {
        // Update UI elements or data that depend on the current language
        spanishLabel.text = card?.text(for: LanguageManager.shared.currentLanguageCode)
        spanishTitle = card?.text(for: LanguageManager.shared.currentLanguageCode) ?? ""
    }
    
    @IBAction func understandButton(_ sender: UIButton){
        switch LanguageManager.shared.currentLanguageCode {
        case "es":
            understoodLabel = "¿Me ha entendido?"
        case "pt":
            understoodLabel = "Você me entendeu?"
        case "fr":
            understoodLabel = "Vous m'avez compris?"
        case "ko":
            understoodLabel = "이해가 되셨나요?"
        case "vi":
            understoodLabel = "Quý vị có hiểu không?"
        default:
            understoodLabel = "Did you understand?"
        }
        playback.content = understoodLabel
        shouldHighlightUtterance = false
        if understandIsPlaying {
            muteUnderstandAudio()
            sender.setImage(UIImage(named: "speaker.wave.2.fill"), for: .normal)
            PendoManager.shared().track("Understand", properties: ["card": englishTitle, "audio": "mute", "locale": LanguageManager.shared.currentLanguageCode])
        } else {
            playback.play()
            understandIsPlaying = true
            refreshUnderstandButton()
            PendoManager.shared().track("Understand", properties: ["card": englishTitle, "audio": "play", "locale": LanguageManager.shared.currentLanguageCode])
        }
    }
    
    func refreshUnderstandButton(){
        // TODO: needs to use the correct button properties, background foreground, etc
        let originalColor = understand.configuration?.background.backgroundColor
        understand.configuration?.background.backgroundColor = originalColor?.withAlphaComponent(0.1)
        understand.configuration?.baseForegroundColor = originalColor?.withAlphaComponent(0.7)
        understand.configuration?.background.strokeWidth = 1
        understand.configuration?.background.strokeColor = originalColor?.withAlphaComponent(0.7)
        understand.configuration?.image = UIImage(systemName: "speaker.slash.fill")
        var attributes = AttributeContainer()
        attributes.font = UIFont.gothamRoundLight20
        understand.configuration?.attributedTitle = AttributedString(understoodLabel, attributes: attributes)
    }
    
    @IBAction func audioTapped(_ sender: UIButton) {
        playback.content = spanishTitle
        shouldHighlightUtterance = true
        audio()
    }
    
    private func audio(){
        if playback.isPlaying {
            stopAudio()
            PendoManager.shared().track("CardDetail", properties: ["card": englishTitle, "audio": "mute", "locale": LanguageManager.shared.currentLanguageCode])
        } else {
            playAudio()
            PendoManager.shared().track("CardDetail", properties: ["card": englishTitle, "audio": "play", "locale": LanguageManager.shared.currentLanguageCode])
        }
    }
    
    private func playAudio() {
        playback.play()
        speaker.setImage(UIImage(named: "speaker_mute"), for: .normal)
        
    }
    
    private func stopAudio() {
        playback.stop()
        speaker.setImage(UIImage(named: "speaker_default"), for: .normal)
    }
    
    private func muteUnderstandAudio(){
        playback.stop()
        understandIsPlaying = false
        resetUnderstandButton()
    }
    
    private func resetUnderstandButton(){
        // Turn understand button back to original state
        understand.configuration?.image = UIImage(systemName: "speaker.wave.2.fill")
        understand.configuration?.background.backgroundColor = UIColor.nurseBlueColor
        understand.configuration?.baseForegroundColor = UIColor.white
        understand.configuration?.background.strokeWidth = 0
        var attributes = AttributeContainer()
        attributes.font = UIFont.gothamRoundLight24 // Wonder if this is causing an issues
        understand.configuration?.attributedTitle = AttributedString("Understand?", attributes: attributes)
    }
    
    func didFinishPlaying(_ service: PlaybackService?) {
        // Reset color
        stopAudio()
        DispatchQueue.main.async {
            self.spanishLabel.textColor = UIColor.nurseBlueColor.withAlphaComponent(1.0)
        }
    }
    
    func highlightSpokenWord(range: NSRange, inString string: String) {
        guard let label = self.spanishLabel, shouldHighlightUtterance else { return }

        let attributedString = NSMutableAttributedString(string: string)
        
        // Apply black background color to the spoken word
        attributedString.addAttribute(.foregroundColor, value: label.textColor.withAlphaComponent(0.6), range: range)

        // Update your label with the highlighted text
        DispatchQueue.main.async {
            label.attributedText = attributedString
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
}
