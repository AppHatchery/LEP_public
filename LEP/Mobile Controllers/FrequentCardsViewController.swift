//
//  FrequentCardsViewController.swift
//  LEP
//
//  Created by Yago Arconada on 10/4/23.
//

import UIKit
import Pendo
import AVFoundation

private let identifier = "FrequentCard"

class FrequentCardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, FrequentCardDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var flagImage: UIImageView!
    var overlayView: UIView!
    
    static var roleSelected: String = ""
    
    var frequentPromptsDisplayed: [Drawer] = Units().general_phrases
    var nurseTasksDisplayed: [[NurseCard]] = Units().general_tasks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        dividerView.dropShadow()
        
        helloLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        helloLabel.addGestureRecognizer(tapGesture)
        
//        configureLanguageMenu()
        setupLanguageButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(roleDidChange), name: .roleDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unitDidChange), name: .unitDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageDidChange, object: nil)
        // Do any additional setup after loading the view.
        
//        printListofVoices()
    }
    
    func setupLanguageButton(){
        languageButton.layer.cornerRadius = 8
    }
    
    private func printListofVoices(){
        let voices = AVSpeechSynthesisVoice.speechVoices()
        guard !voices.isEmpty else {
            print("No voices found")
            return
        }
        for voice in voices {
            print("Voice Identifier: \(voice.identifier), Language: \(voice.language), Name: \(voice.name)")
        }
    }
    
    @IBAction func changeLanguageSelected(_ sender: UIButton){
        showLanguageSelectionMenu()
        PendoManager.shared().track("LanguageMenu", properties: [:])
    }

    @objc func languageChanged(notification: Notification) {
        // Update UI elements or data that depend on the current language
        updateLanguageUI()
        tableView.reloadData()
        NotificationManager.shared.requestPermission()
    }
    
    @objc func roleDidChange() {
        helloLabel.text = "Hello \(RoleManager.shared.currentRoleShortName)!"
        tableView.reloadData()
    }
    
    @objc func unitDidChange() {
        frequentPromptsDisplayed = UnitManager.shared.currentUnitPhrases
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Display role selection when first arriving in app
        if FrequentCardsViewController.roleSelected == "" {
            performSegue(withIdentifier: "Settings", sender: nil)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frequentPromptsDisplayed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FrequentCard
        let cardContent = frequentPromptsDisplayed[indexPath.row]
        
        cell.setupView()
        
        // Rig for Reducing Font size in long phrases (Mostly for Sibley stuff)
        if cardContent.en.count > 72 {
            cell.englishButton.titleLabel?.font = UIFont.gothamRoundBold14
        }
        
        cell.englishButton.setTitle(cardContent.en, for: .normal)
        cell.englishText = cardContent.en
        cell.delegate = self
        
        // Request for Azure simultaneous translation
        
        //        makeRequest(requestText: cardContent.englishTitle, inputLanguage: Model().translateLanguages[0], targetLanguage: Model().speechLanguages[1]) { result in
        //            switch result {
        //            case .success(let translatedText):
        //                DispatchQueue.main.async {
        ////                     Update your UI element here
        //                    cell.spanishText = translatedText
        //                }
        //            case .failure(let error):
        //                print("Error: \(error)")
        //            }
        //        }
        
        //
//        cell.translatedText =  cardContent.es
        cell.translatedText = cardContent.text(for: LanguageManager.shared.currentLanguageCode)
        
        // Determine color choice based on condition
        let colorChoice: UIColor = cardContent.en.contains("?") ? UIColor.nurseBlueColor : UIColor.patientGreenColor

        // Apply the color to various UI elements
        cell.englishButton.layer.borderColor = colorChoice.cgColor
        cell.englishButton.setTitleColor(colorChoice, for: .normal)
        cell.englishButton.backgroundColor = colorChoice.withAlphaComponent(0)
        cell.speakerIcon.tintColor = colorChoice
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("User started scrolling")
        // Pendo Tracking
        PendoManager.shared().track("FrequentCards - Scrolling", properties: ["visible_cards" : cardsVisibleOnScreen()])
    }
    
    func cardsVisibleOnScreen() -> [String] {
        // Get the visible cells
        var visibleCells: [String] = [String]()
        
        // Print the content of each visible cell
        for cell in tableView.visibleCells {
            if let frequentCardCell = cell as? FrequentCard {
                visibleCells.append(frequentCardCell.englishText)
            }
        }
//        print(visibleCells)
        return visibleCells
    }
    
    // Function detects when the user taps on a cell and calls the protocol in FrequentCard.swift
    func cellWillPlay(in cell: FrequentCard, withContent englishContent: String) {
//        print("User tapped a card")
        PendoManager.shared().track("FrequentCards - Select", properties: ["card": englishContent, "visible_cards" : cardsVisibleOnScreen()])
    }
    
    @IBAction func sendFeedback(_ sender: UIButton){
        //
        // Adding notification request here in case they don't touch the language button
        NotificationManager.shared.requestPermission()
        PendoManager.shared().track("feedback", properties: ["thumbs":sender.tag])
    }
    
    @objc func handleLabelTap() {
        // Reset the selected role to allow re-selection
//        presentRoleSelection()
        performSegue(withIdentifier: "Settings", sender: nil)
    }
    
    private func showLanguageSelectionMenu() {
        overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.alpha = 0
        self.view.addSubview(overlayView)

        let popupWidth: CGFloat = 300
        let popupHeight: CGFloat = 400
        let popupFrame = CGRect(x: (self.view.bounds.width - popupWidth) / 2,
                                y: (self.view.bounds.height - popupHeight) / 2,
                                width: popupWidth,
                                height: popupHeight)

        let popupView = LanguageSelectionMenu(frame: popupFrame)
        popupView.alpha = 0
        popupView.closeAction = { [weak self]  in
            self?.dismissPopup()
        }
        
        self.view.addSubview(popupView)

        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 1
            popupView.alpha = 1
        }
    }
    
    private func dismissPopup() {        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
            self.view.subviews.last?.alpha = 0
        }) { _ in
            self.overlayView.removeFromSuperview()
            self.view.subviews.last?.removeFromSuperview()
        }
    }
    
    private func updateLanguageUI() {
        languageButton.setTitle(LanguageManager.shared.currentLanguageName, for: .normal)
        flagImage.image = UIImage(named: LanguageManager.shared.currentLanguageFlag)
        languageButton.backgroundColor = LanguageManager.shared.currentLanguageColor
    }
}


