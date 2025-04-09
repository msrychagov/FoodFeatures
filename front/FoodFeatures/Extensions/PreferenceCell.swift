//
//  PreferenceCell.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 31.03.2025.
//
import UIKit

struct Preference {
    let title: String
    var isSelected: Bool
}

final class PreferenceCell: UITableViewCell {
    //MARK: - Constants
    
    //MARK: - Variables
    private let titleLabel: UILabel = UILabel()
    private let chooseButton: UIButton = UIButton(type: .custom)
    static let reuseIdentifier: String = "PreferenceCell"
    var choosePreference: ((String) -> Void)?
    var didSelectedPreference: (() -> Void)?
    
    //MARK: - LyfeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Не вызываем super, чтобы избежать стандартной анимации выделения
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Не вызываем super, чтобы отключить стандартное выделение
    }
    
    func configure(with preference: Preference) {
        self.backgroundColor = .clear
        titleLabel.text = preference.title
        let imageName = preference.isSelected ? "largecircle.fill.circle" : "circle"
        chooseButton.setImage(UIImage(systemName: imageName), for: .normal)
        configureUI()
    }
    private func configureUI() {
        configureChooseButton()
        configureTitleLabel()
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        contentView.addSubview(titleLabel)
        titleLabel.pinRight(to: contentView, 5)
        titleLabel.pinVertical(to: contentView, 5)
        titleLabel.pinLeft(to: chooseButton.trailingAnchor, 5)
    }
    
    private func configureChooseButton() {
        chooseButton.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        chooseButton.tintColor = .black
        contentView.addSubview(chooseButton)
        chooseButton.pinLeft(to: contentView.leadingAnchor, 5)
        chooseButton.pinVertical(to: contentView, 5)
        chooseButton.setWidth(50)
        chooseButton.addTarget(self, action: #selector (choseButtonTapped), for: .touchUpInside)
    }
    
    @objc func choseButtonTapped() {
        didSelectedPreference?()
    }
}
