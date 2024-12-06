//
//  EstoyController.swift
//  LEP
//
//  Created by Tanishk Deo on 6/3/22.
//

import UIKit
import Pendo

private let reuseIdentifier = "PatientCell"

class EstoyController: UICollectionViewController {
    
    
    let model = Model()
    
    var index: Int? {
        didSet {
            if let index = index {
                switch index {
                case 0:
                    patientCard = Model().patientCards
                case 1:
                    patientCard = Model().familyCards
                    //patientCard = Model().quieroCards
                default:
                    patientCard = [[]]
                }
            }
        }
    }
    
    // Fix to only one for now
    var patientCard = Model().patientCards
    var cardSelected = [0,0]
    

    override func viewWillAppear(_ animated: Bool) {
       
       
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parent = tabBarController?.parent as? PatientController {
            index = parent.index
        }
        
        
        
        collectionView.contentInset = UIEdgeInsets(top: 48, left: 48, bottom: 48, right: 48)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
    

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRect(x: 0,y: 0,width: collectionView.bounds.width-100,height: 200)))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = ["Este iPad es complementario para usted. \nSeñale cómo se siente", "Señale o toque en la pantalla para indicar qué necesita"][indexPath.section]
            lab.font = UIFont.init(name: "Gotham Rounded Bold", size: 52)
//            lab.textColor = UIColor.patientGreenColor
            lab.numberOfLines = 4
            lab.textAlignment = .center
        }
        return v
    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return patientCard[0].count
        case 1:
            return patientCard[1].count
        default:
            return 0
        }
        // #warning Incomplete implementation, return the number of items
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EstoyCell
        
        cell.setupView(card: patientCard[indexPath.section][indexPath.row])
//        if let card = patientCard[indexPath.section] {
//            cell.setupView(card: card[indexPath.row])
//        }

        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let card = patientCard, let vc = tabBarController?.parent as? PatientController {
//            let card = card[indexPath.row]
//            vc.showDetail(card: card)
//        }
        cardSelected = [indexPath.section,indexPath.row]
        PendoManager.shared().track("Patient Detail", properties: ["request": patientCard[cardSelected[0]][cardSelected[1]],"user": (index==1) ? "Family":"Patient"])
        let vc = tabBarController?.parent as? PatientController
        vc?.showDetail(card: patientCard[cardSelected[0]][cardSelected[1]])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Expand", let vc = segue.destination as? EstoyDetailController/*, let sender = sender as? Int, let card = cardSelected*/ {
//            vc.card = card[sender]
            vc.card = Model().patientCards[cardSelected[0]][cardSelected[1]]
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
