//
//  Category.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 07.04.2025.
//

import UIKit

final class AllergenView: UIView {
    //MARK: - Constants
    
    //MARK: - Lyfecycle
    init(frame: CGRect, allergen: Allergen) {
        super.init(frame: frame)
        textLabel.text = allergen.text
        if allergen.text == "Без аллергенов" {
            imageView.image = UIImage(systemName: allergen.imageString)
            imageView.tintColor = .systemGreen
        } else {
            imageView.image = UIImage(named: allergen.imageString)
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Variables
    private let textLabel: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    
    //MARK: - Configures
    private func configureUI() {
        configureView()
        configureImageView()
        configureTextLabel()
    }
    
    private func configureView() {
        self.setHeight(32)
    }
    
    private func configureTextLabel() {
        textLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        self.addSubview(textLabel)
        textLabel.pinLeft(to: imageView.trailingAnchor, 8)
        textLabel.pinRight(to: self.trailingAnchor, 8)
        textLabel.pinCenterY(to: self)
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.pinLeft(to: self.leadingAnchor, 8)
        imageView.setWidth(24)
        imageView.pinCenterY(to: self)
        imageView.pinVertical(to: self)
    }
}
