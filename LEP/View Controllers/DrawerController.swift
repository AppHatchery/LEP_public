//
//  DrawerController.swift
//  LEP
//
//  Created by Tanishk Deo on 6/7/22.
//

import UIKit
import Pendo

class DrawerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PlaybackServiceDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var translationView : UIView!
    @IBOutlet weak var translationText : UILabel!
    @IBOutlet weak var translationPlaceholder : UILabel!
    @IBOutlet weak var translationSpeaker : UIButton!
    
    @IBOutlet weak var responsesList: UICollectionView!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    let reuseIdentifier = "DrawerCell"
    let playback = PlaybackService()
    let layout = LeftAlignedCollectionViewFlowLayout()
    var selectedDrawer = 50
    
    var originalText = ""
        
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translationView.layer.cornerRadius = 20
        displayTranslation(state: false)

        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = -40
        responsesList.flashScrollIndicators()
        responsesList.collectionViewLayout = layout
        responsesList.delegate = self
        responsesList.dataSource = self
        playback.delegate = self
        
        scrollViewHeight.constant = responsesList.collectionViewLayout.collectionViewContentSize.height
        
    }
    
    @IBAction func tapResponses(_ sender: UIButton){
        translationText.text = ""
        displayTranslation(state: true)
        responsesList.reloadData()
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(Model().drawerPrompts.count)
        return Model().drawerPrompts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Model().drawerPrompts[indexPath.row].en.size(withAttributes: [NSAttributedString.Key.font : UIFont(name: "GothamRounded-Medium", size: 24.0) ?? UIFont.systemFont(ofSize: 24.0)]).width
    
        return CGSize(width: width + 80, height: 100)
    }
    

    

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = responsesList.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DrawerCell
        
        cell.setupView()
        cell.contentButton.text = Model().drawerPrompts[indexPath.row].en
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = responsesList.cellForItem(at: indexPath) as! DrawerCell
        
        // Highlight the selected cell
        cell.cellTapped()
        
        // some code for populating the text box
        displayTranslation(state: true)
        
        var text = Model().drawerPrompts[indexPath.row].es
        text = "\"\(text)\""
        
        translationText.text = text
        originalText = Model().drawerPrompts[indexPath.row].en
        
        // Hardcoded way to refresh the cells before a new one gets tapped
        if selectedDrawer == indexPath.row {
            cell.setupView()
            displayTranslation(state: false)
//            print("tapped the same one")
            selectedDrawer = Model().drawerPrompts.count + 1
        } else if selectedDrawer < Model().drawerPrompts.count {
            let selectedCell = responsesList.cellForItem(at: [0,selectedDrawer]) as! DrawerCell
            selectedCell.setupView()
//            print("tapped a different one")
            selectedDrawer = indexPath.row
            PendoManager.shared().track("Drawer", properties: ["prompt":originalText])
        } else {
            selectedDrawer = indexPath.row
            PendoManager.shared().track("Drawer", properties: ["prompt":originalText])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = responsesList.cellForItem(at: indexPath) as! DrawerCell
        
        cell.setupView()
        displayTranslation(state: false)
    }
    
    
    
    func displayTranslation(state: Bool){
        if state {
            translationSpeaker.isHidden = false
            translationText.isHidden = false
            translationPlaceholder.isHidden = true
        } else {
            translationSpeaker.isHidden = true
            translationText.isHidden = true
            translationPlaceholder.isHidden = false
        }
    }
    
    // Audio
    @IBAction func audioTapped(_ sender: UIButton) {
        playback.content = translationText.text
        
        if playback.isPlaying {
            stopAudio()
            print("stopped")
            PendoManager.shared().track("Drawer", properties: ["prompt":originalText,"state":"mute"])
        } else {
            playAudio()
            PendoManager.shared().track("Drawer", properties: ["prompt":originalText,"state":"play"])
        }

    }
    
    private func playAudio() {
        translationSpeaker.setImage(UIImage(named: "speaker_mute"), for: .normal)
        playback.play()
        
    }
    
    private func stopAudio() {
        translationSpeaker.setImage(UIImage(named: "speaker_default"), for: .normal)
        playback.stop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
    
    func didFinishPlaying(_ service: PlaybackService?) {
        stopAudio()
    }
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superArray = super.layoutAttributesForElements(in: rect) else { return nil }

        guard let attributes = NSArray(array: superArray, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }

            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width - 24
            
            
            
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
