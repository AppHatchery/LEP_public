//
//  TasksController.swift
//  LEP
//
//  Created by Tanishk Deo on 5/26/22.
//

import UIKit
import Pendo

private let reuseIdentifier = "NurseCell"

class TasksController: UICollectionViewController {
    
    var nurseCard = Units().general_tasks
    var cardSelected = [0,0]
    let playback = PlaybackService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if StartController.floor == 1 {
//            nurseCard = Units().day_surgery_tasks
//        } else {
//            nurseCard = Units().general_tasks
//        }
        
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
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cardSelected = [indexPath.section,indexPath.row]
        let card = nurseCard[cardSelected[0]][cardSelected[1]]
        if let vc = tabBarController?.parent as? NurseController {
            PendoManager.shared().track("Nurse Task Detail", properties: ["task":nurseCard[cardSelected[0]][cardSelected[1]]])
            vc.showDetail(card: card)
        }
    }
    
  
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRect(x: 0,y: 0,width: 400,height: 60)))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = ["Nursing Tasks", "Vital Signs", "Questions", "Hygiene/Care"][indexPath.section]
//            lab.font = .boldSystemFont(ofSize: 32.0)
            lab.font = UIFont.init(name: "Gotham Rounded Bold", size: 32)
            lab.textAlignment = .left
        }
        return v
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0:
            return nurseCard[0].count
        case 1:
            return nurseCard[1].count
        case 2:
            return nurseCard[2].count
        case 3:
            return nurseCard[3].count
        default:
            return 0
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NurseCell
//        cell.setupCell()
        cell.setupView(card: nurseCard[indexPath.section][indexPath.row])
        
    
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Expand", let vc = segue.destination as? DetailController {
            print(cardSelected)
            vc.card = nurseCard[cardSelected[0]][cardSelected[1]]
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
