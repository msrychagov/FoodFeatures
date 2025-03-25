import UIKit

final class UserInfoView: UIView {
    //MARK: - Constants
    enum Constants {
        enum NameLabel {
            static let font: UIFont = .systemFont(ofSize: 30, weight: .bold)
        }
        enum EditnButton {
            
        }
        enum avatarImageView {
            
        }
        enum General {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
            static let backgroundColor: UIColor = .white
        }
    }
    
    
    // MARK: - Variables
    
    private let containerView = UIView()
    
    private let avatarImageView: UIImageView = UIImageView()
    
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
    func configure(name: String) {
        nameLabel.text = name
        configureUI()
        self.backgroundColor = Constants.General.backgroundColor
    }
    
    func configureUI() {
        configureNameLabel()
    }
    
    func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        nameLabel.font = Constants.NameLabel.font
        self.addSubview(nameLabel)
        nameLabel.pinCenterX(to: self)
        nameLabel.pinCenterY(to: self)
    }
}
