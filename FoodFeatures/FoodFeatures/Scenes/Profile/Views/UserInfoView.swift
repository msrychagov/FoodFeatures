import UIKit

final class UserInfoView: UIView {
    //MARK: - Constants
    enum Constants {
        enum NameLabel {
            static let font: UIFont = .systemFont(ofSize: 30, weight: .bold)
        }
        enum EmailLabel {
            static let font: UIFont = .systemFont(ofSize: 17, weight: .medium)
        }
        enum EditnButton {
            
        }
        
        enum General {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
            static let backgroundColor: UIColor = .white
        }
    }
    
    
    // MARK: - Variables
    
    private let emailLabel: UILabel = UILabel()
    
    private let nameLabel: UILabel = UILabel()
    
    private let editButton: UIButton = UIButton(type: .custom)
    
    // MARK: - Lyfecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    /// Заполняет вью реальными данными
    func configure(name: String, email: String) {
        nameLabel.text = name
        emailLabel.text = email
        configureUI()
    }
    
    func configureUI() {
        configureNameLabel()
        configureEmailLabel()
    }
    
    func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        nameLabel.font = Constants.NameLabel.font
        self.addSubview(nameLabel)
        nameLabel.pinCenterX(to: self)
        nameLabel.pinTop(to: self.topAnchor, 16)
    }
    
    func configureEmailLabel() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        emailLabel.font = Constants.EmailLabel.font
        emailLabel.textColor = .systemGray
        self.addSubview(emailLabel)
        emailLabel.pinCenterX(to: self)
        emailLabel.pinTop(to: nameLabel.bottomAnchor)
    }
}
