//
//  PatientController.swift
//  LEP
//
//  Created by Tanishk Deo on 5/26/22.
//

import UIKit

class PatientController: UIViewController {
    
    
    var childTabBarController: UITabBarController?
    
    let patientColor: UIColor = #colorLiteral(red: 0.283098489, green: 0.7735638022, blue: 0.4475468993, alpha: 1)
    
    var index = 0
    
    var loadedView: UIView!
    var backgroundView: UIView!
    var closeView : UITapGestureRecognizer!
    
    
    @IBOutlet weak var estoyButton: UIButton!
    @IBOutlet weak var quieroButton: UIButton!
    
    @IBOutlet weak var interpreterButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interpreterButton.titleLabel?.textAlignment = .center
        questionButton.titleLabel?.textAlignment = .center
        interpreterButton.dropShadow()
        questionButton.dropShadow()
        
        closeView = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
        
        if let tabController = self.children.first as? UITabBarController {
            childTabBarController = tabController
            selectEstoy()
        }
        
        estoyButton.layer.cornerRadius = 25
        estoyButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        quieroButton.layer.cornerRadius = 25
        quieroButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func estoyTapped(_ sender: UIButton) {
        selectEstoy()
        clearDetailViewsPa()
    }
    
    @IBAction func quieroTapped(_ sender: UIButton) {
        selectQuiero()
        clearDetailViewsPa()
    }
    
    func selectEstoy() {
        if childTabBarController?.selectedIndex != 0  {
            index = 0
            
            childTabBarController?.selectedIndex = 0
            
            estoyButton.backgroundColor = .white
            estoyButton.setTitleColor(.black
                                      , for: .normal)
            
            quieroButton.backgroundColor = patientColor
            quieroButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func selectQuiero() {
        if childTabBarController?.selectedIndex != 1 {
            index = 1
            childTabBarController?.selectedIndex = 1
            index = 1
            estoyButton.backgroundColor = patientColor
            estoyButton.setTitleColor(.white, for: .normal)
            quieroButton.backgroundColor = .white
            quieroButton.setTitleColor(.black, for: .normal)
        }
    }
    
    func showDetail(card: PatientCard) {
        guard let detailView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as? DetailView else {return}
        
        detailView.center = CGPoint(x: self.view.center.x+20.0, y: self.view.center.y+90.0)
        //        detailView.center = self.view.center
        detailView.patientCard = card
        detailView.setupView()
        detailView.alpha = 0.0
        detailView.transform = CGAffineTransform( scaleX: 0, y: 0 )
        detailView.closeButton.addTarget(self, action: #selector(removeBackdrop(_:)), for: .touchDown)
        // Add background
        addBackdrop()
        
        self.view.addSubview(detailView)
        UIView.animate(withDuration: 0.25, animations: {
            detailView.alpha = 1.0
            detailView.transform = CGAffineTransform( scaleX: 1.0, y: 1.0 )
            self.backgroundView.alpha = 0.6
        })
    }
    
    func addBackdrop(){
        backgroundView = UIView(frame: CGRect(x: 0, y: quieroButton.layer.frame.origin.y+quieroButton.layer.frame.height, width: self.view.bounds.width, height: self.view.bounds.height))
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.0
        backgroundView.addGestureRecognizer(closeView)
        self.view.addSubview(backgroundView)
    }
    
    @objc func closeView(_ sender: UIGestureRecognizer){
        for views in self.view.subviews {
            if views.isKind(of: DetailView.self){
                UIView.animate(withDuration: 0.25, animations: {
                    views.alpha = 0
                    views.transform = CGAffineTransform( scaleX: 0.2, y: 0.2 )
                }) { _ in
                    views.removeFromSuperview()
                }
                
            } else if views.isKind(of: QuestionsView.self){
                
                UIView.animate(withDuration: 0.25, animations: {
                    views.alpha = 0
                    views.transform = CGAffineTransform( scaleX: 0.2, y: 0.2 )
                }) { _ in
                    views.removeFromSuperview()
                }
                
                
                resetQuestions(sender)
                
            }
        }
        removeBackdrop(sender)
    }
    
    @objc func removeBackdrop(_ sender: Any){
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.alpha = 0
        }){ _ in
            self.backgroundView.removeFromSuperview()
        }
    }
    
    func showDrawer() {
        
        performSegue(withIdentifier: "Drawer", sender: nil)
        
    }
    
    @IBAction func questionsTapped(_ sender: UIButton) {
        replaceDetailView()
        guard let questionsView = Bundle.main.loadNibNamed("QuestionsView", owner: self, options: nil)?.first as? QuestionsView else {return}
        //        questionsView.center = self.view.center
        questionsView.center = CGPoint(x: self.view.center.x+20.0, y: self.view.center.y+90.0)
        questionsView.setupView()
        questionsView.alpha = 0.0
        questionsView.transform = CGAffineTransform( scaleX: 0, y: 0 )
        questionsView.closeButton.addTarget(self, action: #selector(resetQuestions(_:)), for: .touchDown)
        // Add background
        //        addBackdrop() // not working because background gets removed in this function, seems like you need two steps in order for it to be removed. Potentially there should just be one backdrop for all that gets assigned the close functions for each detail view that appears. Rather than generate a new unattached drop.
        self.view.addSubview(questionsView)
        self.questionButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            questionsView.alpha = 1.0
            questionsView.transform = CGAffineTransform( scaleX: 1.0, y: 1.0 )
            self.questionButton.alpha = 0.2
            self.backgroundView.alpha = 0.6
        })
        { _ in
            // Remove the old view
            for views in self.view.subviews {
                if views.isKind(of: DetailView.self){
                    views.removeFromSuperview()
                }
            }
        }
    }
    
    // Add a replace detail view function but maintain backdrop functionality
    func replaceDetailView(){
        for views in self.view.subviews {
            if views.isKind(of: DetailView.self){
                views.removeFromSuperview()
            }
        }
        if let backDropView = backgroundView {
            if self.view.subviews.contains(backDropView){
                print("has backdrop")
            } else {
                print("doesn't have backdrop")
                addBackdrop()
            }
        } else {
            addBackdrop()
        }
    }
    func clearDetailViewsPa(){
        for views in self.view.subviews {
            if views.isKind(of: QuestionsView.self){
                views.removeFromSuperview()
                resetQuestions(self)
                removeBackdrop(self)
            }
            else if views.isKind(of: IntroView.self){
                views.removeFromSuperview()
                removeBackdrop(self)
            }
            else if views.isKind(of: DetailView.self){
                views.removeFromSuperview()
                removeBackdrop(self)
            }
        }
    }
    
    @objc func resetQuestions(_ sender: Any){
        self.questionButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.1, animations: {
            self.questionButton.alpha = 1
        }) { _ in
            self.removeBackdrop(sender)
        }
    }
    
    // remove other windows prior to showing interpreter page
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "contactInterpreter" {
    //            for views in self.view.subviews {
    //                if views.isKind(of: DetailView.self){
    //                    views.removeFromSuperview()
    //                }
    //                else if views.isKind(of: QuestionsView.self){
    //                    views.removeFromSuperview()
    //                }
    //            }
    //        }
    //    }
}



