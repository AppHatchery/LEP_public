//
//  SpeechRecognitionManager.swift
//  LEP
//
//  Created by Yago Arconada on 11/19/24.
//

import MicrosoftCognitiveServicesSpeech
import Foundation

class SpeechRecognitionManager {
    private var reco: SPXTranslationRecognizer?
    private var isDisposing = false
    private let cleanupQueue = DispatchQueue(label: "com.speech.cleanup")
    
    func initialize(recognizer: SPXTranslationRecognizer) {
        cleanupQueue.sync {
            self.reco = recognizer
            self.isDisposing = false
        }
    }
    
    func cleanup(completion: (() -> Void)? = nil) {
        cleanupQueue.async { [weak self] in
            guard let self = self,
                  let recognizer = self.reco,
                  !self.isDisposing else {
                DispatchQueue.main.async {
                    completion?()
                }
                return
            }
            
            self.isDisposing = true
            
            // Create a cleanup timeout
            let timeoutWorkItem = DispatchWorkItem {
                print("Recognition stop timed out, forcing cleanup")
                self.forceCleanup()
                DispatchQueue.main.async {
                    completion?()
                }
            }
            
            // Schedule timeout
            DispatchQueue.global().asyncAfter(deadline: .now() + 3.0, execute: timeoutWorkItem)
            
            do {
                try recognizer.stopContinuousRecognition()
                // If stop succeeds, cancel timeout and cleanup
                timeoutWorkItem.cancel()
                self.forceCleanup()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                print("Error stopping recognition: \(error)")
                // Even on error, ensure cleanup happens
                timeoutWorkItem.cancel()
                self.forceCleanup()
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    private func forceCleanup() {
        self.reco = nil
        self.isDisposing = false
    }
}
