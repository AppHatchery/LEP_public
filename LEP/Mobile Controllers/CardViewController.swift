//
//  CardViewController.swift
//  LEP
//
//  Created by Yago Arconada on 9/28/23.
//

import UIKit

private let reuseIdentifier = "NurseCell"
private let cardSelectionIdentifier = "CardTag"

class CardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var cardSelectionCollectionView: UICollectionView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    var nurseCardsDisplayed = Roles().general_tasks
    let selections = ["All", "Nursing Tasks", "Vital Signs", "Questions", "Hygiene/Card"]
    var selectedItemIndex = 0
    var cardSelected = 0
    
    var isRoleSelected = false
    
    let tap = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard dismissal recognizer
        tap.addTarget(self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        dividerView.dropShadow()
        setupLanguageButton()
        updateLanguageUI()
        NotificationManager.shared.requestPermission()
//
//        let delegate1 = CustomCollectionViewDelegate1(collectionView: cardCollectionView)
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        cardSelectionCollectionView.delegate = self
        cardSelectionCollectionView.dataSource = self
        
        search.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(unitDidChange), name: .unitDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func languageChanged(notification: Notification) {
        // Update UI elements or data that depend on the current language
        print("language should have changed")
        updateLanguageUI()
    }
    
    func setupLanguageButton(){
        languageButton.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        nurseCardsDisplayed = UnitManager.shared.currentUnitTasks
        
        // Add all tasks to position 0 of the array
        let flattenedArray: [NurseCard] = nurseCardsDisplayed.flatMap { $0 }
        nurseCardsDisplayed.insert(flattenedArray, at: 0)
        
        let viewWidth = cardCollectionView.frame.width
        let predictedWidth = 20 * 2 + 100 * 3 + 2 * 8
        
        print(viewWidth)
        if viewWidth > CGFloat(predictedWidth) {
            cardCollectionView.contentInset = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        } else {
            cardCollectionView.contentInset = UIEdgeInsets(top: 16, left: 40, bottom: 16, right: 40)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Code to update search results
    }
    
    @objc func unitDidChange() {
        nurseCardsDisplayed = UnitManager.shared.currentUnitTasks
        cardCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cardCollectionView {
            return nurseCardsDisplayed[selectedItemIndex].count
        } else if collectionView == cardSelectionCollectionView {
            return selections.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        if collectionView == cardCollectionView {
            let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardView
            cell.setupView(card: nurseCardsDisplayed[selectedItemIndex][indexPath.row])
            
            return cell
        } else if collectionView == cardSelectionCollectionView {
            let cell = cardSelectionCollectionView.dequeueReusableCell(withReuseIdentifier: cardSelectionIdentifier, for: indexPath) as! CardTag
            cell.setupView()
            cell.contentButton.text = selections[indexPath.row]
            
            // To maintain highlighted the item selected while the collection view recycles due to performance
            if indexPath.row == selectedItemIndex {
                cardSelectionCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
            
            return cell
        } else {
            // Handle the case where neither collection view matches (if needed)
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cardCollectionView {
            print("Selection Card")
            cardSelected = indexPath.row
//            let cell = cardCollectionView.cellForItem(at: indexPath) as! NurseCell
//            let card = nurseCard[indexPath.row]
//            // Edit what happens when the user taps the card
            performSegue(withIdentifier: "SegueToMobileDetailVC", sender: nil )
        } else if collectionView == cardSelectionCollectionView {
            print("Selection Tag")
            // Clear out previous item
            // Bad implementation, should be using select and deselect class
            if let previousCard = cardSelectionCollectionView.cellForItem(at: [0,selectedItemIndex]) as? CardTag {
                    previousCard.tagTapped()
            }
            
            // Select the new item
            selectedItemIndex = indexPath.row
            
            // Change the selection of the content that is being displayed
            cardCollectionView.flashScrollIndicators()
            cardCollectionView.reloadData()
        }
    }

    func didFinishPlaying(_ service: PlaybackService?) {
        //
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // This code does not work because the CollectionView Cells have a TapGestureRecognizer as well, ideally they would be using their native gesture recognizer so that I don't have to add a manual one. To be tested in a separate screen for functionality.
        tap.cancelsTouchesInView = true
        tap.isEnabled = true
    }
    
    private func updateLanguageUI() {
        languageLabel.text = LanguageManager.shared.currentLanguageName
        flagImage.image = UIImage(named: LanguageManager.shared.currentLanguageFlag)
        languageButton.backgroundColor = LanguageManager.shared.currentLanguageColor
    }
                                                  
    @objc func dismissKeyboard() {
        // To hide the keyboard when the user clicks search
        tap.isEnabled = false
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MobileDetailViewController {
            vc.card = nurseCardsDisplayed[selectedItemIndex][cardSelected]
            vc.englishTitle = nurseCardsDisplayed[selectedItemIndex][cardSelected].en_long
            vc.spanishTitle = nurseCardsDisplayed[selectedItemIndex][cardSelected].text(for: LanguageManager.shared.currentLanguageCode)
            vc.imageTitle = nurseCardsDisplayed[selectedItemIndex][cardSelected].image
        }
    }
}

class CustomCollectionViewDelegate1: NSObject, UICollectionViewDelegateFlowLayout {
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let collectionView = self.collectionView else {
            return CGSize.zero
        }
        
        _ = collectionView.frame.height
        _ = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        _ = collectionView.contentInset
        
//        let availableHeight = collectionViewHeight - sectionInset.top - sectionInset.bottom - contentInset.top - contentInset.bottom
        let cellWidth = 60 // Set your desired cell width
        let cellHeight = 130 // Set your desired cell height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
