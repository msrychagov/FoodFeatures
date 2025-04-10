//
//  SignUpUserData.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 15.03.2025.
//


import UIKit

final class UserDataView: UIView {
    //MARK: Constants
    enum Constants {
        enum View {
            static let height: CGFloat = 70
            static let width: CGFloat = 320
        }
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
        
        enum ViewNames {
            static let email: String = "Почта"
            static let password: String = "Пароль"
        }
    }
    //MARK: - Variables
    let textField: UITextField = UITextField()
    private let label: UILabel = UILabel()
    private let textFieldPlaceholder: String?
    var getText: ((String) -> Void)?
    weak var delegate: UserDataViewDelegate?
    
    //MARK: LyfeCycles
    init (textFieldPlaceholder: String?) {
        self.textFieldPlaceholder = textFieldPlaceholder
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configureUI() {
        configureView()
        configureTextField()
    }
    
    func configureView() {
        self.setWidth(Constants.View.width)
        self.setHeight(Constants.View.height)
    }
    
    func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        textField.font = Constants.TextField.font
        textField.textColor = Constants.TextField.textColor
        textField.backgroundColor = Constants.TextField.backgroundColor
        textField.layer.cornerRadius = Constants.TextField.cornerRadius
        textField.layer.masksToBounds = true
        textField.layer.sublayerTransform = Constants.TextField.leftTab
        textField.placeholder = textFieldPlaceholder
        settingTextField()
        textField.addTarget(self, action: #selector(didTextChanged), for: .editingChanged)
        self.addSubview(textField)
        textField.pinCenterX(to: self)
        textField.pinCenterY(to: self)
        textField.setWidth(Constants.TextField.width)
        textField.setHeight(Constants.TextField.height)
    }
    
    func settingTextField() {
        if textFieldPlaceholder == Constants.ViewNames.email {
            textField.keyboardType = .emailAddress  // Показывает @ и .com
            textField.autocapitalizationType = .none // Отключаем автозаглавные буквы
            textField.autocorrectionType = .no // Отключаем автокоррекцию
            textField.textContentType = .emailAddress // Улучшает автозаполнение
        } else if textFieldPlaceholder == Constants.ViewNames.password {
            textField.isSecureTextEntry = true // Прячет вводимые символы
            textField.keyboardType = .default // Обычная клавиатура
//            textField.textContentType = .password // Автозаполнение паролей
        }
    }
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        label.font = Constants.Label.font
        label.textColor = Constants.Label.textColor
        label.backgroundColor = Constants.Label.backgroundColor
        
        self.addSubview(label)
        label.pinLeft(to: textField.leadingAnchor, Constants.Label.lefConstraint)
        label.pinBottom(to: textField.topAnchor, Constants.Label.bottomConsraint)
    }
    
    func setText(text: String) {
        textField.text = text
    }
    //MARK: - Actions
    @objc func didTextChanged() {
        delegate?.userDataView(type: textFieldPlaceholder ?? "",text: textField.text ?? "")
    }
}
