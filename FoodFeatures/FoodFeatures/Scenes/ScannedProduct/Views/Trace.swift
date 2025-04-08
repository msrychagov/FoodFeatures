//
//  Trace.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 07.04.2025.
//


import UIKit

final class TraceView: UIView {
    //MARK: - Constants
    
    //MARK: - Lyfecycle
    init(frame: CGRect, trace: String) {
        super.init(frame: frame)
        textLabel.text = trace
        if trace == "Нет следов аллергенов" {
            imageView.image = UIImage(systemName: "checkmark.square.fill")
            imageView.tintColor = .systemGreen
            imageView.setWidth(24)
            imageView.setHeight(24)
        } else {
            imageView.image = UIImage(systemName: "circle.fill")
            imageView.tintColor = .black
            imageView.setWidth(8)
            imageView.setHeight(8)
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
        textLabel.pinVertical(to: self)
        textLabel.pinRight(to: self.trailingAnchor)
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.pinLeft(to: self.leadingAnchor, 8)
        imageView.pinCenterY(to: self)
        imageView.pinVertical(to: self)
    }
}
