//
//  IntroDetailController.swift
//  LEP
//
//  Created by Yago Arconada on 6/27/22.
//

import UIKit


class IntroDetailController: UIViewController,PlaybackServiceDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var spanishTitleLabel: UILabel!
    @IBOutlet weak var englishTitleLabel: UILabel!
    @IBOutlet var spanishTitleSecondLabel: UILabel!
    @IBOutlet weak var englishTitleSecondLabel: UILabel!
    @IBOutlet weak var timeSegmented: UISegmentedControl!
    
    @IBOutlet weak var firstSpeaker: UIButton!
    @IBOutlet weak var secondSpeaker: UIButton!
    
    let playback = PlaybackService()
    
    var spanishTitle: String?
    var englishTitle: String?
    var card: IntroCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate view with card content
        spanishTitleSecondLabel.text = "Iré a ver cómo estás cada:"
        englishTitleSecondLabel.text = "I’ll come check on you every:"
        spanishTitle = card?.spanishSecondTitle
        englishTitle = card?.englishSecondTitle
        imageView.image = UIImage(named: card!.image)
        spanishTitleLabel.text = spanishTitle
        englishTitleLabel.text = englishTitle
        // Do any additional setup after loading the view.
        
        playback.delegate = self
    }
    
    @IBAction func audioTapped(_ sender: UIButton) {
        
        if sender.tag == 0 {
            spanishTitle = card?.spanishSecondTitle
            guard let spanishTitle = spanishTitle else {
                return
            }
            playback.content = spanishTitle
            
            if playback.isPlaying {
                stopAudio(button: sender)
            } else {
                playAudio(button: sender)
            }
        } else {
            spanishTitle = "Iré a ver cómo estás cada: "
            guard let spanishTitle = spanishTitle else {
                return
            }

            playback.content = spanishTitle
            
            if playback.isPlaying {
                stopAudio(button: sender)
            } else {
                playAudio(button: sender)
            }
        }
        
    }
    
    private func playAudio(button: UIButton) {
        button.setImage(UIImage(named: "speaker_mute"), for: .normal)
        playback.play()
        
    }
    
    private func stopAudio(button: UIButton) {
        button.setImage(UIImage(named: "speaker_default"), for: .normal)
        
        playback.stop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        playback.stop()
    }
    
    func didFinishPlaying(_ service: PlaybackService?) {
        stopAudio(button: firstSpeaker)
        stopAudio(button: secondSpeaker)
    }
    
    @IBAction func close(_ sender: UIButton) {
        presentingViewController?
            .dismiss(animated: true, completion: nil)
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
