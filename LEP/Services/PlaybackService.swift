//
//  PlaybackService.swift
//  LEP
//
//  Created by Tanishk Deo on 6/13/22.
//

import Foundation
import AVFoundation
import UIKit


class PlaybackService: NSObject, AVSpeechSynthesizerDelegate {
    
    var delegate: PlaybackServiceDelegate?
    var audioPlaybackDelegate: AudioPlaybackDelegate? // Retain the delegate
    
    var content: String?
    
    var isPlaying = false
    
    let synthesizer = AVSpeechSynthesizer()
    var audioPlayer = AVAudioPlayer()
    
//    let voice = AVSpeechSynthesisVoice(language: Model().speechLanguages[1])
    var voice = AVSpeechSynthesisVoice(language: LanguageManager.shared.currentLocale)
    
    // Closures
    var onSpeakRange: ((NSRange, String) -> Void)?
    var onSpeakCompletion: (() -> Void)?
    
    
    override init() {
        super.init()
        synthesizer.delegate = self
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        } catch {
            print("Failed to set audio session category.")
        }
        
        // Register for language change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageDidChange, object: nil)
    }
    
    
    init(string: String) {
        self.content = string
        super.init()
        synthesizer.delegate = self
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        } catch {
            print("Failed to set audio session category.")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func languageDidChange(notification: Notification) {
        voice = AVSpeechSynthesisVoice(language: LanguageManager.shared.currentLocale)
    }
    
    func play(language: String? = nil) {
        if let content = content, !isPlaying {
            let utterance = AVSpeechUtterance(string: content)
            utterance.voice = language != nil ? AVSpeechSynthesisVoice(language: language) : voice
            utterance.rate = 0.45 // Adjust as needed for specific languages
            synthesizer.speak(utterance)
            isPlaying = true
        }
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isPlaying = false
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlaying = false
        delegate?.didFinishPlaying(self)
        onSpeakCompletion?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        // Convert NSRange to Range<String.Index> for string manipulation
        onSpeakRange?(characterRange, utterance.speechString)
    }
    
    func playSound(named soundName: String, completion: (() -> Void)? = nil) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "m4a") else {
            print("Sound file \(soundName) not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlaybackDelegate = AudioPlaybackDelegate(completion: completion) // Retain the delegate
            audioPlayer.delegate = audioPlaybackDelegate
            audioPlayer.play()
        } catch {
            print("Failed to play sound \(soundName): \(error.localizedDescription)")
        }
    }
}

// Custom Delegate for Playback Completion
class AudioPlaybackDelegate: NSObject, AVAudioPlayerDelegate {
    private let completion: (() -> Void)?

    init(completion: (() -> Void)?) {
        self.completion = completion
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        completion?()
    }
}

protocol PlaybackServiceDelegate {
    func didFinishPlaying(_ service: PlaybackService?)
}

