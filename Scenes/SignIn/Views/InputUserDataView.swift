//
//  InputUserDataTextField.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 14.03.2025.
//

import UIKit

final class InputUserDataView: UIView {
    //MARK: Constants
    enum Constants {
        enum TextField {
            static let font: UIFont = .systemFont(ofSize: 20, weight: .regular)
            static let textColor: UIColor = .black
            static let backgroundColor: UIColor = .white
            static let cornerRadius: CGFloat = 20
            static let width: CGFloat = 300
            static let height: CGFloat = 60
            static let leftTab: CATransform3D = CATransform3DMakeTranslation(10,0,0)
        }
        enum Label {
            static let font: UIFont = .systemFont(ofSize: 25, weight: .bold)
            static let textColor: UIColor = .black
            static let backgroundColor: UIColor = .clear
            static let lefConstraint: CGFloat = 10
            static let bottomConsraint: CGFloat = 5
            
        }
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    //MARK: - Variables
    private let textField: UITextField = UITextField()
    private let label: UILabel = UILabel()
    private var labelText: String?
    private var textFieldPlaceholder: String?
    
    //MARK: LyfeCycles
    init (labelText: String?, textFieldPlaceholder: String?) {
        self.labelText = labelText
        self.textFieldPlaceholder = textFieldPlaceholder
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configureUI() {
        configureView()
        configureTextField()
        configureLabel()
    }
    
    func configureView() {
        self.setWidth(320)
        self.setHeight(100)
    }
    
    func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        textField.font = Constants.TextField.font
        textField.textColor = Constants.TextField.textColor
        textField.backgroundColor = Constants.TextField.backgroundColor
        textField.layer.cornerRadius = Constants.TextField.cornerRadius
        textField.layer.masksToBounds = true
        textField.layer.sublayerTransform = Constants.TextField.leftTab
        textField.placeholder = textFieldPlaceholder
        
        self.addSubview(textField)
        textField.pinCenterX(to: self)
        textField.pinCenterY(to: self)
        textField.setWidth(Constants.TextField.width)
        textField.setHeight(Constants.TextField.height)
    }
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        label.font = Constants.Label.font
        label.textColor = Constants.Label.textColor
        label.text = labelText
        label.backgroundColor = Constants.Label.backgroundColor
        
        self.addSubview(label)
        label.pinLeft(to: textField.leadingAnchor, Constants.Label.lefConstraint)
        label.pinBottom(to: textField.topAnchor, Constants.Label.bottomConsraint)
    }
}
