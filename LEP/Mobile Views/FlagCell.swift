//
//  LanguageFlagCellCollectionViewCell.swift
//  LEP
//
//  Created by Yago Arconada on 6/17/24.
//

import UIKit

class FlagCell: UICollectionViewCell {
    static let reuseIdentifier = "FlagCell"
    
    let flagImageView = UIImageView()
    let languageLabel = UILabel()
    
    private var highlightColor: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor

        flagImageView.layer.cornerRadius = 10
        flagImageView.layer.masksToBounds = true
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(flagImageView)

        languageLabel.textAlignment = .center
        languageLabel.font = UIFont.gothamRoundBold8
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(languageLabel)

        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            flagImageView.heightAnchor.constraint(equalToConstant: 32),
            
            languageLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 5),
            languageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            languageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with flag: (String, String, String, String), highlightColor: UIColor) {
        flagImageView.image = UIImage(named: flag.2)
        languageLabel.text = flag.1
        self.highlightColor = highlightColor
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                if let highlightColor = highlightColor {
                    contentView.layer.borderColor = highlightColor.cgColor
                    contentView.backgroundColor = highlightColor
                }
            } else {
                contentView.layer.borderColor = UIColor.clear.cgColor
                contentView.backgroundColor = .white
            }
        }
    }
}

