//
//  PainView.swift
//  LEP
//
//  Created by Tanishk Deo on 10/1/22.
//

import UIKit
import Pendo

class PainView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let redColor = UIColor(red: 0.91, green: 0.44, blue: 0.44, alpha: 1.00)
    
    @IBOutlet weak var spanishLabel: UILabel!
    
    @IBOutlet weak var englishLabel: UILabel!
    
    let dict = ["head": " la cabeza",
                "throat": "la garganta",
                "left shoulder": "el hombro izquierdo",
                "right shoulder": "el hombro derecho",
                "left arm": "el brazo izquierdo",
                "right arm": "el brazo derecho",
                "left elbow": "el codo izquierdo",
                "right elbow": "el codo derecho",
                "chest": "el pecho",
                "stomach": "el estómago",
                "left hand": "la mano izquierda",
                "right hand": "la mano derecha",
                "hip": "las caderas",
                "left thigh": "el muslo izquierdo",
                "right thigh": "el muslo derecho",
                "left knee": "la rodilla izquierda",
                "right knee": "la rodilla derecha",
                "left leg": "la pierna izquierda",
                "right leg": "la pierna derecha",
                "right foot": "el pie derecho",
                "left foot": "el pie izquierdo"]
    let dictBack = ["hip" : ["bottom", "los glúteos"], "chest": ["back", "la espalda"], "stomach": ["back", "la espalda"], "throat": ["neck", "el cuello"]]
     
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var bodyDiagram: UIImageView!
    @IBOutlet var painButtons: [UIButton]!
    
    @IBOutlet weak var painSpanishText: UILabel!

    func setupView() {
        closeButton.dropShadow()
        for button in painButtons {
            button.tintColor = .clear
            button.isUserInteractionEnabled = false
            button.layer.cornerRadius = (button.frame.height/2)
            button.layer.masksToBounds = true
        }
        
        bodyDiagram.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(diagramTapped(_:))))
    }
    
    let instructionPlayback = PlaybackService(string: "Toque donde le duele")
    @IBAction func instructionsTapped(_ sender: UIButton) {
        instructionPlayback.play()
    }
    
    let spanishPlayback = PlaybackService()
    
    @IBAction func spanishTapped(_ sender: UIButton) {
        let message = "\(painSpanishText.text ?? "") \(spanishLabel.text ?? "")"

        spanishPlayback.content = message
        spanishPlayback.play()
    }
  
    var drawLine = false
    var origin = CGPoint(x: 0, y: 0)
    
    @objc func diagramTapped(_ sender: UIGestureRecognizer) {
        let tappedPoint = sender.location(in: bodyDiagram)
        let button = findClosestButton(point: tappedPoint)
        
        if button.tintColor != .red {
            for painButton in painButtons {
                painButton.tintColor = .clear
            }
            button.tintColor = redColor
           
            drawLine = true
            origin = CGPoint(x: button.frame.midX, y: button.frame.midY)
            drawConnectingLine()
            
            if var label = button.accessibilityLabel, var text = dict[label] {
                
                if back == true, let arr = dictBack[label]{
                    label = arr[0]
                    text = arr[1]
                }
                
                PendoManager.shared().track("Body diagram", properties: ["body part":label])
                
                if text.hasSuffix("s") {
                    painSpanishText.text = "Me duelen"
                } else {
                    painSpanishText.text = "Me duele"
                }
    
                let attrSpanish = NSAttributedString(string: text, attributes: [.underlineStyle: NSUnderlineStyle.thick.rawValue, .font : UIFont(name: "GothamRounded-Bold", size: 40.0) ?? UIFont.systemFont(ofSize: 40.0), .foregroundColor: UIColor.patientGreenColor])
                let attrEnglish = NSMutableAttributedString(string: "My \(label) is hurting."
, attributes: [.font : UIFont(name: "GothamRounded-Light", size: 40.0) ?? UIFont.systemFont(ofSize: 40.0)])
                attrEnglish.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue], range: NSString(string: attrEnglish.string).range(of: label, options: String.CompareOptions.caseInsensitive))
                spanishLabel.attributedText = attrSpanish
                englishLabel.attributedText = attrEnglish
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            button.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    private func findClosestButton(point: CGPoint) -> UIButton {
        var min: UIButton!
        var curr: Float!
        for button in painButtons {
            if min != nil, curr != nil {
                let distance = hypotf(Float(button.frame.midX - point.x), Float(button.frame.midY - point.y))
                if distance < curr {
                    curr = distance
                    min = button
                }
            } else {
                min = button
                let distance = hypotf(Float(button.frame.midX - point.x), Float(button.frame.midY - point.y))
                
                curr = distance
            }
        }
        
        return min
    }
    
    
    var back = false

    @IBAction func flipView(_ sender: UIButton? = nil) {
        
        reset()
        
        if bodyDiagram.image == UIImage(named: "front_body_diagram") {
            bodyDiagram.image = UIImage(named: "back_body_diagram")
            back = true
        } else {
            bodyDiagram.image = UIImage(named: "front_body_diagram")
            back = false
        }
        
    }
    
    
    func reset() {
        self.layer.sublayers?.filter{$0 is CAShapeLayer}.forEach{$0.removeFromSuperlayer()}
        for painButton in painButtons {
            painButton.tintColor = .clear
        }
        
        spanishLabel.text = "__________________."
        englishLabel.text = "My _______ is hurting."
        
    }
    

    
    func drawConnectingLine() {
        self.layer.sublayers?.filter{$0 is CAShapeLayer}.forEach{$0.removeFromSuperlayer()}
        if drawLine {
            let shapeLayer = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x:origin.x, y:origin.y))
            path.addLine(to: CGPoint(x: 260.0, y: 245.0))
            path.move(to: CGPoint(x:258.5, y: 245.0))
            path.addLine(to: CGPoint(x: 290.0, y: 245.0))
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = redColor.cgColor
            shapeLayer.lineWidth = 5.0
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    
    @IBAction func close(_ sender: UIButton?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform( scaleX: 0.2, y: 0.2 )
        }) { _ in
            self.removeFromSuperview()
        }
    }

}
