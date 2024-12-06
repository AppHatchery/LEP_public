//
//  DetailController.swift
//  LEP
//
//  Created by Tanishk Deo on 5/27/22.
//

import UIKit


class DetailController: UIViewController, PlaybackServiceDelegate {
    
    @IBOutlet weak var alternateTask: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var spanishTitleLabel: UILabel!
    @IBOutlet weak var englishTitleLabel: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    
    let playback = PlaybackService()
    
    var spanishTitle: String?
    var englishTitle: String?
    var card: NurseCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(alternateTapped(_:)))
        
        alternateTask.addGestureRecognizer(tap)
        
        playback.delegate = self
        
        
        // Populate view with card content
        spanishTitle = card?.es
        englishTitle = card?.en
        imageView.image = UIImage(named: card!.image)
        spanishTitleLabel.text = spanishTitle
        englishTitleLabel.text = englishTitle
        
        // Do any additional setup after loading the view.
    }
    
    @objc func alternateTapped(_ sender: UITapGestureRecognizer) {
        showAlternate()
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
    
    func showAlternate() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "Detail") as? DetailController {
            
            vc.spanishTitle = "Estoy sacando la via intravenosa."
            vc.englishTitle = "I am taking out the IV"
            self.present(vc, animated: true, completion: nil)
            
        }
        
        
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
