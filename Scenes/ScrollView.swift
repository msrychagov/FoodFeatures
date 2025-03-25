//
//  ScrollView.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 23.03.2025.
//

import UIKit

class ScrollViewController: UIViewController {
    
    // Создаем scrollView и контентный view
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Настройка scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Добавляем contentView в scrollView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            // Привязываем края contentView к scrollView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // Очень важно задать ширину, равную ширине scrollView,
            // чтобы scrollView определял вертикальный скроллинг
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Используем UIStackView для удобного размещения элементов
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // Пример добавления нескольких элементов (например, меток)
        for i in 1...20 {
            let label = UILabel()
            label.text = "Элемент \(i)"
            label.textAlignment = .center
            label.backgroundColor = .lightGray
            // Задаем фиксированную высоту для каждой метки
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(label)
        }
    }
}
