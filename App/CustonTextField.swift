//
//  CustonTextField.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 14.03.2025.
//

import UIKit

class CustomTextField: UIView {
    //MARK: - Constants
    enum Constants {
        enum TextField {
            static let font: UIFont = .systemFont(ofSize: 30, weight: .bold)
            static let textColor: UIColor = .black
            static let backgroundColor: UIColor = .white
            static let cornerRadius: CGFloat = 10
            static let width: CGFloat = 300
            static let leftView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
            static let leftViewMode: UITextField.ViewMode = .always
            static let placeholderColor: UIColor = .gray
            static let placeholder: String = "Введите почту"
        }
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints = false
        }
    }
    private let titleLabel: UILabel = UILabel()
    private let textField: UITextField = UITextField()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureTitleLabel()
        configureTextField()
    }
    
    private func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите почту"
        textField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 0
        textField.layer.masksToBounds = true
        // Добавляем отступ слева
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.leftViewMode = .always
        self.addSubview(textField)
        textField.pinTop(to: titleLabel.bottomAnchor)
        textField.pinRight(to: self.trailingAnchor)
        textField.pinLeft(to: self.leadingAnchor)
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .white
        titleLabel.text = "Почта:"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = UIColor.gray
        
        self.addSubview(titleLabel)
        titleLabel.pinTop(to: self.topAnchor)
        
    }
}
