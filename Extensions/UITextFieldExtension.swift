//
//  TextField.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 14.03.2025.
//

import UIKit

extension UITextField {
    static func createTextField(placeholder: String) -> UITextField{
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 30, weight: .bold)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always
        textField.setWidth(300)
        return textField
    }
}
