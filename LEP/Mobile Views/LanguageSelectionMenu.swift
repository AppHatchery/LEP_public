//
//  LanguageSelectionMenu.swift
//  LEP
//
//  Created by Yago Arconada on 6/17/24.
//

import UIKit
import Pendo

class LanguageSelectionMenu: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    var selectedLocale: String = "es-ES"
    
    // Define a closure property for the close action
    var closeAction: (() -> Void)?
    
    var languageKeys = Array(LanguageManager.shared.languageCodeMap.keys)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        // Sort the keys to maintain the same order
        languageKeys.sort()
        
        let titleLabel = UILabel()
        titleLabel.text = "Choose the language you want to translate to:"
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.gothamRoundBook14
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 74, height: 74)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(FlagCell.self, forCellWithReuseIdentifier: FlagCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        
        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Select", for: .normal)
        selectButton.titleLabel?.font = UIFont.gothamRoundMedium16
        selectButton.setTitleColor(UIColor.white, for: .normal)
        selectButton.backgroundColor = UIColor.nurseBlueColor
        selectButton.layer.cornerRadius = 16
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        self.addSubview(selectButton)
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: selectButton.topAnchor, constant: -20),
            
            selectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            selectButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            selectButton.widthAnchor.constraint(equalToConstant: 100),
            selectButton.heightAnchor.constraint(equalToConstant: 32),
            
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languageKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlagCell.reuseIdentifier, for: indexPath) as! FlagCell
        let key = languageKeys[indexPath.item]
        if let flag = LanguageManager.shared.languageCodeMap[key] {
            cell.configure(with: (key, flag.namecaps, flag.flag, flag.locale), highlightColor: flag.color)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = languageKeys[indexPath.item]
        if let flag = LanguageManager.shared.languageCodeMap[key] {
            if let cell = collectionView.cellForItem(at: indexPath) as? FlagCell {
                cell.flagImageView.layer.borderColor = flag.color.cgColor
                cell.flagImageView.backgroundColor = flag.color
                selectedLocale = flag.locale
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FlagCell {
            cell.flagImageView.layer.borderColor = UIColor.clear.cgColor
            cell.flagImageView.backgroundColor = .white
        }
    }
    
    @objc private func closeButtonTapped() {
        // Assuming you want to pass the color of the currently selected cell
        closeAction?()
    }
    
    @objc private func saveButtonTapped() {
        // Assuming you want to pass the color of the currently selected cell
        LanguageManager.shared.setCurrentLocale(to: selectedLocale)
        PendoManager.shared().track("LanguageSelect", properties: ["locale":LanguageManager.shared.currentLanguageCode])
        closeAction?()
    }
}

