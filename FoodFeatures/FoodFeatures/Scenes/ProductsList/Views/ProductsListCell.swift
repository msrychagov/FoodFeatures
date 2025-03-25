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
        enum Wrap {
            static let cornerRadius: CGFloat = 15
            static let bootomConstraint: CGFloat = 30
        }
        enum TitleLabel {
            static let font: UIFont = .systemFont(ofSize: 9, weight: .medium)
            static let numberOfLines: Int = 2
        }
        enum ImageView {
            static let clipsToBounds: Bool = true
            static let contentMode: UIView.ContentMode = .scaleAspectFit
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
        wrap.layer.cornerRadius = Constants.Wrap.cornerRadius
        contentView.addSubview(wrap)
        wrap.pinTop(to: contentView)
        wrap.pinHorizontal(to: contentView)
        wrap.pinBottom(to: contentView, Constants.Wrap.bootomConstraint)
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        titleLabel.font = Constants.TitleLabel.font
        titleLabel.numberOfLines = Constants.TitleLabel.numberOfLines
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.pinTop(to: wrap.bottomAnchor)
        titleLabel.pinHorizontal(to: contentView)
        titleLabel.pinBottom(to: contentView.bottomAnchor)
        
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        imageView.clipsToBounds = Constants.ImageView.clipsToBounds
        imageView.contentMode = Constants.ImageView.contentMode
        contentView.addSubview(imageView)
        imageView.pin(to: wrap)
    }

}
