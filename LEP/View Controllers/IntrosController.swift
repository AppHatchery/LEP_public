//
//  IntrosController.swift
//  LEP
//
//  Created by Yago Arconada on 6/27/22.
//

import UIKit
import AVFAudio
import Pendo

private let reuseIdentifier = "IntroCell"

class IntrosController: UICollectionViewController {
    
    var introCards = Model().introCards
    var cardSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 48, left: 48, bottom: 48, right: 48)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return introCards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cardSelected = indexPath.row
        if let vc = tabBarController?.parent as? NurseController {
            PendoManager.shared().track("Nurse Intro Detail", properties: ["intro":introCards[cardSelected]])
            let card = introCards[cardSelected]
            vc.showIntro(card: card)
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IntroCell
        cell.setupView(card: introCards[indexPath.row])
        
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Expand", let vc = segue.destination as? IntroDetailController {

            vc.card = introCards[cardSelected]
        }
    }
}

