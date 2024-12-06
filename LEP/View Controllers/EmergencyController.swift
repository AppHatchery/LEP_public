//
//  EmergencyController.swift
//  LEP
//
//  Created by Tanishk Deo on 6/3/22.
//

import UIKit


class EmergencyController: UIViewController, PlaybackServiceDelegate {
    
    @IBOutlet weak var speakerButton: UIButton!
    
    let emergencyMessage = "Hay una emergencia en esta habitación. Les pedimos a todos los padres que salgan. Alguien le llamará más tarde"
    
    let playback = PlaybackService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playback.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func speakerTapped(_ sender: UIButton) {
        playback.content = emergencyMessage
        
        if playback.isPlaying {
            speakerButton.setImage(UIImage(named: "speaker_default"), for: .normal)
            
            playback.stop()
        } else {
            playback.play()
            speakerButton.setImage(UIImage(named: "speaker_mute"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        playback.stop()
    }
    
    func didFinishPlaying(_ service: PlaybackService?) {
        speakerButton.setImage(UIImage(named: "speaker_default"), for: .normal)
        playback.stop()
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
