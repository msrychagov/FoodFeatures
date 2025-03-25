//
//  ProductsListCell.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 23.03.2025.
//
import UIKit
final class ProductsListCell: UICollectionViewCell {
    //MARK: - Constants
    enum Constants {
        enum General {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    //MARK: - Variables
    static let reuseIdentifier: String = "ProductsListCell"
    private let titleLabel: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    private let wrap: UIView = UIView()
    //MARK: - Lifycycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configure(title: String, imageUrl: String) {
        titleLabel.text = title
        guard let url = URL(string: imageUrl) else {
                    return
                }
                
                // Запускаем асинхронную загрузку
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    // Если ошибка или данных нет, просто выходим
                    guard let data = data, error == nil else {
                        return
                    }
                    // Создаём UIImage из полученных данных
                    let downloadedImage = UIImage(data: data)
                    
                    // Обновление интерфейса всегда делаем на главном потоке
                    DispatchQueue.main.async {
                        self?.imageView.image = downloadedImage
                    }
                }.resume()
        configureUI()
    }
    
    private func configureUI() {
        configureWrap()
        configureTitleLabel()
        configureImageView()
    }
    
    private func configureWrap() {
        wrap.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        wrap.backgroundColor = .white
        wrap.layer.cornerRadius = 15
        contentView.addSubview(wrap)
        wrap.pinTop(to: contentView)
        wrap.pinHorizontal(to: contentView)
        wrap.pinBottom(to: contentView, 30)
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        titleLabel.font = .systemFont(ofSize: 9, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.pinTop(to: wrap.bottomAnchor)
        titleLabel.pinHorizontal(to: contentView)
        titleLabel.pinBottom(to: contentView.bottomAnchor)
        
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.pin(to: wrap)
    }

}
