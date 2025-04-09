//
//  TitleCell.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 06.04.2025.
//

import UIKit

final class TitleCell: UITableViewCell {
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: - Variables
    static let reuseIdentifier = "TitleCell"
    private let titleLabel: UILabel = UILabel()
    
    //MARK: Lyfecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    private func configureUI() {
        configureTitleLabel()
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        titleLabel.text = "Ограничения"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        contentView.addSubview(titleLabel)
        titleLabel.pinCenterY(to: contentView)
        titleLabel.pinLeft(to: contentView.leadingAnchor, 16)
    }
}
