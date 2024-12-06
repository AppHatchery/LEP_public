//
//  PainController.swift
//  LEP
//
//  Created by Yago Arconada on 7/5/22.
//

import UIKit

class PainController: UIViewController, PlaybackServiceDelegate {
    
    @IBOutlet weak var toggleSwitch: UISegmentedControl!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var painDiagram: UIImageView!
    @IBOutlet var painDiagramAssets: [UIView]!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var frontButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var expandButton: UIImageView!
    
    @IBOutlet var painScaleMarkers: [UIButton]!
    @IBOutlet var painScaleFaces: [UIImageView]!
    
    private var parentController: NurseController?
    
    let backPlayback = PlaybackService(string: "de espalda")
    let frontPlayback = PlaybackService(string: "de frente")
    let titlePlayback = PlaybackService()
    
    var activeFace: Int!
    var activeScaleIndicator: CGFloat!
    var sliderIndicator: UIView!
    
    @IBOutlet weak var frontDiagram: UIImageView!
    
    @IBOutlet weak var backDiagram: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentController = tabBarController?.parent as? NurseController
        
        let tapTitle = UITapGestureRecognizer(target: self, action: #selector(titleTapped(_:)))
        
        titleButton.addGestureRecognizer(tapTitle)
        
        backDiagram.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backDiagramTapped(_:))))
        frontDiagram.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frontDiagramTapped(_:))))
        expandButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frontDiagramTapped(_:))))
        
        for face in painScaleFaces {
            face.isUserInteractionEnabled = true
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapFace(_:)))
            face.addGestureRecognizer(recognizer)
        }
        
        titlePlayback.delegate = self
        
        
        toggleSwitch.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GothamRounded-Light", size: 38) ?? UIFont.boldSystemFont(ofSize: 38), NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
        toggleSwitch.selectedSegmentTintColor = UIColor.nurseBlueColor
        toggleSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white ], for: .selected)
        
        
        toggleSwitch.layer.cornerRadius = toggleSwitch.bounds.height / 2
        toggleSwitch.layer.borderColor = UIColor.white.cgColor
        toggleSwitch.layer.borderWidth = 1.0
        toggleSwitch.layer.masksToBounds = true
        
        for but in painScaleMarkers {
            but.dropShadow()
        }
        
        //        toggleSwitch.setTitleTextAttributes([NSAttributedString.Key.strokeColor:UIColor.white], for: .selected)
        //        toggleSwitch.setTitleTextAttributes([NSAttributedString.Key.strokeColor:UIColor.gray], for: .normal)
        
        toggleToPainScoreDiagram()
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func frontDiagramTapped(_ sender: UITapGestureRecognizer) {
        openDiagramView(front: true)
    }
    
    @objc func backDiagramTapped(_ sender: UITapGestureRecognizer) {
        openDiagramView(front: false)
    }
    
    
    
    
    func openDiagramView(front: Bool) {
        parentController?.showPainView(front: front)
    }
    
    
    @objc func titleTapped(_ sender: UITapGestureRecognizer) {
        if let title = bottomLabel.text {
            titlePlayback.content = title
            if titlePlayback.isPlaying {
                titleButton.setImage(UIImage(named: "speaker_default"), for: .normal)
                titlePlayback.stop()
            } else {
                titleButton.setImage(UIImage(named: "speaker_mute"), for: .normal)
                titlePlayback.play()
            }
        }
    }
    
    func didFinishPlaying(_ service: PlaybackService?) {
        if let service = service {
            if service == titlePlayback {
                titleButton.setImage(UIImage(named: "speaker_default"), for: .normal)
            }
            
        }
    }
    
    @IBAction func highlightPainScale(_ sender: UIButton){
        print("tapped")
        // Face Animation
        UIView.animate(withDuration: 0.25) {
            for face in self.painScaleFaces {
                face.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        } completion: { _ in
            // Animate face growing
            UIView.animate(withDuration: 0.5) {
                self.painScaleFaces[Int(round(Double((sender.tag+1)/2)))].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            } completion: { _ in
                self.activeFace = sender.tag
                print("done face")
            }
        }
        
        // Slider animation
        if sliderIndicator != nil {
            let displacement = sender.frame.origin.x - sliderIndicator.frame.origin.x
            UIView.animate(withDuration: 0.5) {
                print(displacement)
                self.sliderIndicator.frame.origin.x = self.sliderIndicator.frame.origin.x + displacement
                //                self.sliderIndicator.transform = CGAffineTransform(translationX: displacement, y: 0) // Transform seems to stack rather than replace
            } completion: { _ in
                print("Done slide")
                if self.sliderIndicator != nil {
                    self.activeScaleIndicator = self.sliderIndicator.frame.origin.x
                }
            }
        } else {
            sliderIndicator = UIView(frame: sender.frame)
            sliderIndicator.backgroundColor = UIColor(red: 196/255, green: 33/255, blue: 38/255, alpha: 0.4)
            sliderIndicator.layer.cornerRadius = sender.layer.cornerRadius
            sliderIndicator.dropShadow()
            view.addSubview(sliderIndicator)
            
            let tapIndicator = UITapGestureRecognizer(target: self, action: #selector(tapSlider) )
            sliderIndicator.addGestureRecognizer(tapIndicator)
            
            
            activeScaleIndicator = sliderIndicator.frame.origin.x
        }
    }
    
    @objc func tapFace(_ sender: UITapGestureRecognizer) {
        if let face = sender.view {
            let tag = face.tag
            UIView.animate(withDuration: 0.25) {
                for face in self.painScaleFaces {
                    face.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            } completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    face.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                } completion: { _ in
                    self.activeFace = tag
                }
            }
            
            
            if let button = painScaleMarkers.first(where: {$0.tag == tag}) {
                            
                if sliderIndicator != nil {
                    let displacement = button.frame.origin.x - sliderIndicator.frame.origin.x
                    UIView.animate(withDuration: 0.5) {
                        self.sliderIndicator.frame.origin.x = self.sliderIndicator.frame.origin.x + displacement
                    } completion: { _ in
                        if self.sliderIndicator != nil {
                            self.activeScaleIndicator = self.sliderIndicator.frame.origin.x
                        }
                    }
                } else {
                    sliderIndicator = UIView(frame: button.frame)
                    sliderIndicator.backgroundColor = UIColor(red: 196/255, green: 33/255, blue: 38/255, alpha: 0.4)
                    sliderIndicator.layer.cornerRadius = button.layer.cornerRadius
                    sliderIndicator.dropShadow()
                    view.addSubview(sliderIndicator)
                    
                    let tapIndicator = UITapGestureRecognizer(target: self, action: #selector(tapSlider) )
                    sliderIndicator.addGestureRecognizer(tapIndicator)
                    
                    activeScaleIndicator = sliderIndicator.frame.origin.x
                }
            }
        }
    }
    
    
    @objc func tapSlider(){
        print("tapped slider")
        UIView.animate(withDuration: 0.05) {
            self.sliderIndicator.transform = CGAffineTransform( translationX: 0, y: -20 )
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.sliderIndicator.transform = CGAffineTransform( translationX: 0, y: 0 )
            }
        }
    }
    
    @IBAction func animatePainScale(_ sender: UITapGestureRecognizer){
        clearPainScale()
    }
    
    func clearPainScale(){
        for but in painScaleMarkers {
            but.backgroundColor = UIColor.clear
        }
        UIView.animate(withDuration: 0.25) {
            for face in self.painScaleFaces {
                face.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        
        if sliderIndicator != nil {
            UIView.animate(withDuration: 0.25) {
                self.sliderIndicator.transform = CGAffineTransform( scaleX: 0.001, y: 0.001 )
            } completion: { _ in
                self.sliderIndicator.removeFromSuperview()
                self.activeScaleIndicator = nil
                self.sliderIndicator = nil
            }
        }
    }
    
    
    @IBAction func togglePain(_ sender: UISegmentedControl) {
        
        print(sender.selectedSegmentIndex)
        
        if sender.selectedSegmentIndex == 0{
            // If pain diagram
            topLabel.text = "Point to the face or number that best shows your level of pain."
            bottomLabel.text = "Señale la cara o el número que mejor muestre su nivel de dolor."
            topLabel.isHidden = false
            toggleToPainScoreDiagram()
        } else {
            // If body diagram
            topLabel.text = "Where does it hurt? Point to the areas on this diagram if you can."
            bottomLabel.text = "¿Dónde le duele? Señale las áreas de este diagrama si puede."
            topLabel.isHidden = false
            toggleToBodyDiagram()
        }
    }
    
    func toggleToBodyDiagram(){
        for asset in painDiagramAssets {
            asset.isHidden = false
            asset.layer.cornerRadius = 15
            asset.layer.borderWidth = 3
            asset.layer.borderColor = UIColor.lightGray.cgColor
            
            
        }
        clearPainScale()
        painDiagram.isHidden = true
        for face in painScaleFaces {
            face.isHidden = true
        }
        for but in painScaleMarkers {
            but.backgroundColor = UIColor.clear
            but.isHidden = true
        }
    }
    
    func toggleToPainScoreDiagram(){
        for asset in painDiagramAssets {
            asset.isHidden = true
        }
        painDiagram.isHidden = false
        for face in painScaleFaces {
            face.isHidden = false
        }
        for but in painScaleMarkers {
            but.backgroundColor = UIColor.clear
            but.isHidden = false
        }
    }
}
