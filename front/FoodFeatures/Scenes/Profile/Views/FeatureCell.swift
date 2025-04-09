//
//  FeatureCell.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 06.04.2025.
//

import UIKit

final class FeatureCell: UITableViewCell {
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: - Variables
    static let reuseIdentifier = "FeatureCell"
    private let titleLabel: UILabel = UILabel()
    
    //MARK: Lyfecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    func configure(feature: String?) {
        titleLabel.text = feature
        configureTitleLabel()
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(titleLabel)
        titleLabel.pinLeft(to: contentView.leadingAnchor, 24)
        titleLabel.pinVertical(to: contentView, 8)
    }
}
