//
//  InterpreterController.swift
//  LEP
//
//  Created by Tanishk Deo on 6/17/22.
//

import UIKit

class InterpreterController: UIViewController, PlaybackServiceDelegate {
    
    
    
    
    @IBOutlet weak var speakerButton: UIButton!
    
    
    let playback = PlaybackService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callButton.layer.cornerRadius = 20
        callButton.clipsToBounds = true
        
        playback.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
 
    @IBOutlet weak var callButton: UIButton!
    
    @IBAction func understandTapped(_ sender: UIButton) {
        callButton.backgroundColor = #colorLiteral(red: 0.283098489, green: 0.7735638022, blue: 0.4475468993, alpha: 1)
        callButton.setTitleColor(.white, for: .normal)
        let interpreterButton = UIAlertController(title: "To call an interpreter please exit this app and launch the CyraCom Interpreter app installed in this device", message: "", preferredStyle: .alert)
        interpreterButton.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(interpreterButton, animated: true,completion: nil)
    }
    
    @IBAction func audioTapped(_ sender: UIButton) {

        playback.content = "Estoy llamando a un intérprete."
        
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

