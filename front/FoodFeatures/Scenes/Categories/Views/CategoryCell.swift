//
//  CategoryCell.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 21.03.2025.
//
import UIKit

struct Category {
    let title: String
    let image: String
    let id: Int
}


class CategoryCell: UICollectionViewCell {
    
    //MARK: - Constants
    enum Constants {
        
    }
    static let reuseIdentifier = "CategoryCell"
    private let imageView: UIImageView = UIImageView()
    
    private let wrap: UIView = UIView()
    
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Настраиваем внешний вид ячейки (например, закруглённые углы, бэкграунд)
        contentView.layer.masksToBounds = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Метод для конфигурации ячейки данными
    func configure(category: Category) {
//        contentView.backgroundColor = .green
        titleLabel.text = category.title
        imageView.image = UIImage(named: category.image)
        configureWrap()
        configureImageView()
        configureTitleLabel()
    }
    
    private func configureWrap() {
        wrap.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrap)
//        wrap.backgroundColor = .blue
        wrap.pinTop(to: contentView)
        wrap.pinHorizontal(to: contentView)
        wrap.pinBottom(to: contentView, 40)
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        titleLabel.font = .systemFont(ofSize: 25, weight: .medium)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.pinTop(to: wrap.bottomAnchor, 3)
        titleLabel.pinBottom(to: contentView, 3)
        titleLabel.pinHorizontal(to: contentView)
    }
    
     private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
         imageView.layer.cornerRadius = 15
        contentView.addSubview(imageView)
         imageView.pin(to: wrap)
    }
}
