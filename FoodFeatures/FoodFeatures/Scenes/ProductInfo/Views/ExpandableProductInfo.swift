import UIKit

final class ExpandableProductInfoView: UIView {
    
    // MARK: - Свойства
    private var isExpanded = false
    
    private let titleLabel: UILabel = UILabel()
    private let arrowButton: UIButton = UIButton()
    
    /// StackView, в котором лежит и заголовок, и блок деталей
    private let mainStackView: UIStackView = UIStackView()
    
    /// Отдельный горизонтальный стек для заголовка (Label + Button)
    private let headerStackView: UIStackView = UIStackView()
    
    /// Вертикальный стек с «деталями»
    private let detailsStackView: UIStackView = UIStackView()
    
    /// Пример лейблов
    private let producerLabel: UILabel = UILabel()
    
    private let countryLabel: UILabel = UILabel()
    
    private let compositionLabel: UILabel = UILabel()
    
    
    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    /// Заполнить лейблы информацией
    func configure(title: String, descriptionfields: [DescriptionField]) {
        titleLabel.text = title
        for descriptionfield in descriptionfields {
            let currentLabel: UILabel = UILabel()
            currentLabel.text = "\(descriptionfield.title): \(descriptionfield.value)"
            currentLabel.numberOfLines = 0
            currentLabel.lineBreakMode = .byWordWrapping
            detailsStackView.addArrangedSubview(currentLabel)
        }
        
        if title == "Общие характеристики" {
            detailsStackView.isHidden = false
            isExpanded = true
            arrowButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        } else {
            detailsStackView.isHidden = true
            isExpanded = false
            arrowButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        }
        
        configureUI()
    }
    
    func configureUI() {
        configureTitleLabel()
        configureArrowButton()
        configureMainStackView()
        configureHeaderStackView()
        configureDetailsStackView()
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    func configureArrowButton() {
        arrowButton.tintColor = .black
        //        arrowButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        //        arrowButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    func configureMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        
    }
    
    func configureHeaderStackView() {
        headerStackView.axis = .horizontal
    }
    
    func configureDetailsStackView() {
        detailsStackView.axis = .vertical
        detailsStackView.spacing = 8
    }
    
    
    // MARK: - Настройка View
    private func setupViews() {
        // Заголовок: складываем в горизонтальный стек
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(arrowButton)
        // Настраиваем выравнивание, чтобы кнопка не растягивалась
        headerStackView.alignment = .center
        headerStackView.distribution = .equalSpacing
        
        
        
        // Главный стек: сверху заголовок, снизу детали
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(detailsStackView)
        addSubview(mainStackView)
        
        // Назначаем действие кнопке
        arrowButton.addTarget(self, action: #selector(toggleExpanded), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        ///MainStackConstraints
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.pinLeft(to: self, 16)
        mainStackView.pinRight(to: self, 40)
        mainStackView.pinVertical(to: self, 8)
        
    }
    
    private func setupTapGesture() {
        // Добавляем жест на всю шапку (StackView) — это и будет «кликаемым» заголовком
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleExpanded))
        headerStackView.isUserInteractionEnabled = true
        headerStackView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleExpanded() {
        isExpanded.toggle()
        
        let newImageName = isExpanded ? "chevron.down" : "chevron.left"
        arrowButton.setImage(UIImage(systemName: newImageName), for: .normal)
        
        // Анимированно скрываем/показываем detailsStackView:
        UIView.animate(withDuration: 0.3) {
            self.detailsStackView.isHidden = !self.isExpanded
            // Важно: если нам нужно, чтобы анимация стека просчиталась,
            // вызываем layoutIfNeeded() у родителя (или у self).
            self.layoutIfNeeded()
        }
    }
}
