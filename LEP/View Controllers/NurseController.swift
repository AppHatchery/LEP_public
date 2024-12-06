//
//  NurseController.swift
//  LEP
//
//  Created by Tanishk Deo on 5/26/22.
//

import UIKit

class NurseController: UIViewController {
    
    
    var childTabBarController: UITabBarController?
    let nurseColor: UIColor = #colorLiteral(red: 0.1803921569, green: 0.7529411765, blue: 0.8980392157, alpha: 1)
    var backgroundView: UIView!
    var closeView : UITapGestureRecognizer!
    
    @IBOutlet weak var tasksButton: UIButton!
    @IBOutlet weak var painButton: UIButton!
    @IBOutlet weak var introButton: UIButton!
    
    @IBOutlet weak var emergencyButton: UIButton!
    
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var interpreterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        questionButton.titleLabel?.textAlignment = .center
        interpreterButton.titleLabel?.textAlignment = .center
        questionButton.dropShadow()
        interpreterButton.dropShadow()
        emergencyButton.dropShadow()
        
        closeView = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
        
        if let tabController = self.children.first as? UITabBarController {
            childTabBarController = tabController
            selectTasks()
        }
        
        
        
        tasksButton.layer.cornerRadius = 25
        tasksButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        painButton.layer.cornerRadius = 25
        painButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        introButton.layer.cornerRadius = 25
        introButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
    }
    @IBAction func questionsTapped(_ sender: UIButton) {
        replaceDetailView()
        if questionButton.isHighlighted {
            guard let questionsView = Bundle.main.loadNibNamed("QuestionsView", owner: self, options: nil)?.first as? QuestionsView else {return}
            //        questionsView.center = self.view.center
            questionsView.center = CGPoint(x: self.view.center.x+20.0, y: self.view.center.y+90.0)
            questionsView.setupView()
            questionsView.alpha = 0.0
            questionsView.transform = CGAffineTransform( scaleX: 0, y: 0 )
            self.view.addSubview(questionsView)
            questionsView.closeButton.addTarget(self, action: #selector(resetQuestionsNurse(_:)), for: .touchDown)
            self.questionButton.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25, animations: {
                questionsView.alpha = 1.0
                self.questionButton.alpha = 0.2
                questionsView.transform = CGAffineTransform( scaleX: 1.0, y: 1.0 )
                self.backgroundView.alpha = 0.6
            }) { _ in
                for views in self.view.subviews {
                    if views.isKind(of: DetailView.self){
                        views.removeFromSuperview()
                    }
                    else if views.isKind(of: IntroView.self){
                        views.removeFromSuperview()
                    }
                    else if views.isKind(of: PainView.self){
                        views.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    
    
    
    
    @IBAction func tasksTapped(_ sender: UIButton) {
        selectTasks()
    }
    
    func showDetail(card: NurseCard) {
        guard let detailView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as? DetailView else {return}
        detailView.center = CGPoint(x: self.view.center.x+50.0, y: self.view.center.y+90.0)
        //        detailView.center = self.view.center
        detailView.nurseCard = card
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
    
    func addBackdrop() {
        backgroundView = UIView(frame: CGRect(x: 0, y: introButton.layer.frame.origin.y+introButton.layer.frame.height, width: self.view.bounds.width, height: self.view.bounds.height))
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
                
            } else if views.isKind(of: IntroView.self){
                UIView.animate(withDuration: 0.25, animations: {
                    views.alpha = 0
                    views.transform = CGAffineTransform( scaleX: 0.2, y: 0.2 )
                }) { _ in
                    views.removeFromSuperview()
                }
                
            }
            else if views.isKind(of: QuestionsView.self){
                
                UIView.animate(withDuration: 0.25, animations: {
                    views.alpha = 0
                    views.transform = CGAffineTransform( scaleX: 0.2, y: 0.2 )
                }) { _ in
                    views.removeFromSuperview()
                }
                
                resetQuestionsNurse(sender)
                
            }
            else if views.isKind(of: PainView.self) {
                (views as? PainView)?.close(nil)
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
    
    @objc func resetQuestionsNurse(_ sender: Any){
        self.questionButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.questionButton.alpha = 1
        }) { _ in
            self.removeBackdrop(sender)
        }
    }
    
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
    
    
    func showDrawer() {
        performSegue(withIdentifier: "Drawer", sender: nil)
    }
    
    func showIntro(card: IntroCard) {
        guard let introView = Bundle.main.loadNibNamed("IntroView", owner: self, options: nil)?.first as? IntroView else {return}
        introView.center = CGPoint(x: self.view.center.x+50.0, y: self.view.center.y+90.0)
        //        detailView.center = self.view.center
        
        introView.card = card
        introView.setupView()
        introView.alpha = 0.0
        introView.transform = CGAffineTransform( scaleX: 0, y: 0 )
        introView.closeButton.addTarget(self, action: #selector(removeBackdrop(_:)), for: .touchDown)
        // Add background
        addBackdrop()
        self.view.addSubview(introView)
        UIView.animate(withDuration: 0.25, animations: {
            introView.transform = CGAffineTransform( scaleX: 1.0, y: 1.0 )
            introView.alpha = 1.0
            self.backgroundView.alpha = 0.6
        }) { _ in
            for views in self.view.subviews {
                if views.isKind(of: DetailView.self){
                    views.removeFromSuperview()
                }
            }
        }
    }
    
    func showPainView(front: Bool) {
        guard let diagramView = Bundle.main.loadNibNamed("PainView", owner: self, options: nil)?.first as? PainView else {return}
        diagramView.center = CGPoint(x: self.view.center.x+50.0, y: self.view.center.y+90.0)
        if !front {
            diagramView.flipView()
        }
        diagramView.alpha = 0.0
        diagramView.transform = CGAffineTransform( scaleX: 0, y: 0 )
        diagramView.closeButton.addTarget(self, action: #selector(removeBackdrop(_:)), for: .touchDown)
        addBackdrop()
        self.view.addSubview(diagramView)
        diagramView.setupView()
        UIView.animate(withDuration: 0.25, animations: {
            diagramView.alpha = 1.0
            diagramView.transform = CGAffineTransform( scaleX: 1.0, y: 1.0 )
            self.backgroundView.alpha = 0.6
        })
    }
    
    func selectTasks() {
        if childTabBarController?.selectedIndex != 0 {
            childTabBarController?.selectedIndex = 0
            tasksButton.backgroundColor = .white
            tasksButton.setTitleColor(.black
                                      , for: .normal)
            
            painButton.backgroundColor = nurseColor
            painButton.setTitleColor(.white, for: .normal)
            introButton.backgroundColor = nurseColor
            introButton.setTitleColor(.white, for: .normal)
        }
        clearDetailViews()
    }
    
    @IBAction func painTapped(_ sender: Any) {
        selectPain()
    }
    
    @IBAction func introsTapped(_ sender: UIButton) {
        selectIntros()
    }
    
    func selectPain() {
        if childTabBarController?.selectedIndex != 1 {
            childTabBarController?.selectedIndex = 1
            painButton.backgroundColor = .white
            painButton.setTitleColor(.black, for: .normal)
            tasksButton.backgroundColor = nurseColor
            tasksButton.setTitleColor(.white, for: .normal)
            introButton.backgroundColor = nurseColor
            introButton.setTitleColor(.white, for: .normal)
        }
        clearDetailViews()
    }
    
    func clearDetailViews(){
        for views in self.view.subviews {
            if views.isKind(of: QuestionsView.self){
                views.removeFromSuperview()
                resetQuestionsNurse(self)
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
            else if views.isKind(of: PainView.self){
                views.removeFromSuperview()
                removeBackdrop(self)
            }
        }
    }
    
    func selectIntros() {
        if childTabBarController?.selectedIndex != 2 {
            childTabBarController?.selectedIndex = 2
            introButton.backgroundColor = .white
            introButton.setTitleColor(.black, for: .normal)
            
            tasksButton.backgroundColor = nurseColor
            tasksButton.setTitleColor(.white, for: .normal)
            painButton.backgroundColor = nurseColor
            painButton.setTitleColor(.white, for: .normal)
        }
        clearDetailViews()
    }
    
    @IBAction func callInterpreter(_ sender: UIButton) {
        
        let interpreterButton = UIAlertController(title: "To call an interpreter please exit this app and launch the CyraCom Interpreter app installed in this device", message: "", preferredStyle: .alert)
        interpreterButton.addAction(UIAlertAction(title: "OK", style: .default))
        //         This feature is unavailable because requires CyraCom to have enabled URL schemes for us to launch it directly from the App. Alternatively they be routed to the AppStore
        //        interpreterButton.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
        //            //
        //            print("Trying to open the app")
        //            let url = URL(string: "https://apps.apple.com/us/app/cyracom-interpreter/id1389494604")
        //
        //            UIApplication.shared.open(url!) { (result) in
        //                if result {
        //                    //
        //                    print("CyraCom was launched successfully")
        //                }
        //            }}))
        self.present(interpreterButton, animated: true,completion: nil)
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
