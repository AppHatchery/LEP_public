//
//  EstoyDetailController.swift
//  LEP
//
//  Created by Tanishk Deo on 6/13/22.
//

import UIKit

class EstoyDetailController: UIViewController, PlaybackServiceDelegate {

    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var englishTitleLabel: UILabel!
    @IBOutlet weak var spanishTitleLabel: UILabel!
    
    let playback = PlaybackService()
    
    var spanishTitle: String?
    var englishTitle: String?
    var card: PatientCard?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        understandButton.layer.cornerRadius = 20
        understandButton.clipsToBounds = true
        
        playback.delegate = self
        
        if let card = card {
            spanishTitle = card.es
            englishTitle = card.en
        }
        
        if let spanishTitle = spanishTitle, let englishTitle = englishTitle {
            imageView.image = UIImage(named: card!.image)
            spanishTitleLabel.text = spanishTitle
            englishTitleLabel.text = englishTitle
        }
        
        // Do any additional setup after loading the view.
    }
    
    
 
    @IBOutlet weak var understandButton: UIButton!
    
    @IBAction func understandTapped(_ sender: UIButton) {
        if understandButton.backgroundColor == UIColor.inactiveButtonColor {
            understandButton.backgroundColor = #colorLiteral(red: 0.283098489, green: 0.7735638022, blue: 0.4475468993, alpha: 1)
            understandButton.tintColor = .white
        } else {
            understandButton.backgroundColor = UIColor.inactiveButtonColor
            understandButton.tintColor = .black
        }
    }
    
    @IBAction func audioTapped(_ sender: UIButton) {
        guard let spanishTitle = spanishTitle else {
            return
        }
        playback.content = spanishTitle
        
        if playback.isPlaying {
            stopAudio()
        } else {
            playAudio()
        }

    }
    
    private func playAudio() {
        speakerButton.setImage(UIImage(named: "speaker_mute"), for: .normal)
        playback.play()
        
    }
    
    private func stopAudio() {
        speakerButton.setImage(UIImage(named: "speaker_default"), for: .normal)
        
        playback.stop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
    
    func didFinishPlaying(_ service: PlaybackService?) {
        stopAudio()
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
