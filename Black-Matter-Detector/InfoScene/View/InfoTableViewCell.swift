//
//  InfoTableViewCell.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import Foundation
import UIKit

class InfoTableViewCell: UITableViewCell {
    public static let reuseIdentifier = "InfoCell"
    private let indexLabel = UILabel()
    private let infoLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutInfo()
        
    }
    
    func setup(info: PresentedInfoModel) {
        indexLabel.text = "\(info.id)"
        infoLabel.text = info.info
    }
    
    private func layoutInfo() {
        self.addSubview(indexLabel)
        self.addSubview(infoLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        indexLabel.font = .systemFont(ofSize: 24, weight: .bold)
        infoLabel.font = .systemFont(ofSize: 16)
        indexLabel.numberOfLines = 0
        infoLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            indexLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            indexLabel.widthAnchor.constraint(equalToConstant: 128),
            indexLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 32),
            infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
