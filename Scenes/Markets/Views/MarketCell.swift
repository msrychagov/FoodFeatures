//
//  MarketCell.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 22.03.2025.
//
import UIKit

struct Market {
    let title: String
    let image: String
    let id: Int
}

class MarketCell: UITableViewCell {
    //MARK: - Constants
    enum Constants {
        enum General {
            static let translatesAutoresizingMaskIntoConstraints = false
            static let backgroundColor: UIColor = .clear
        }
        enum Wrap {
            static let verticalConstraint: CGFloat = 10
        }
        enum ImageView {
            static let cornerRadius: CGFloat = 50
            static let clipsToBounds: Bool = true
            static let contentMode: UIView.ContentMode = .scaleAspectFit
        }
    }
    
    //MARK: - Variables
    private let marketImageView: UIImageView = UIImageView()
    static let reuseIdentifier: String = "MarketCell"
    private var aspectConstraint: NSLayoutConstraint?
    private let wrap: UIView = UIView()
    
    //MARK: - Lyfecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configure(image: UIImage) {
        self.backgroundColor = Constants.General.backgroundColor
        // Сбрасываем предыдущий constraint (если ячейка переиспользуется)
//        aspectConstraint?.isActive = false
        
        // Считаем новое соотношение сторон (height / width)
        let ratio = image.size.height / image.size.width
        
        // Создаём constraint: высота = ширина * ratio
        
        aspectConstraint = marketImageView.pinHeight(
            to: marketImageView.widthAnchor,
            ratio
        )
        aspectConstraint?.isActive = true
        
        // Устанавливаем картинку
        marketImageView.image = image
        configureUI()
    }
    
    private func configureUI() {
        configureWrap()
        configureMarketImageView()
    }
    
    private func configureWrap() {
        wrap.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrap)
        wrap.pinVertical(to: contentView, Constants.Wrap.verticalConstraint)
        wrap.pinHorizontal(to: contentView)
    }
    
    private func configureMarketImageView() {
        marketImageView.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        marketImageView.clipsToBounds = Constants.ImageView.clipsToBounds
        marketImageView.contentMode = Constants.ImageView.contentMode
        marketImageView.layer.cornerRadius = Constants.ImageView.cornerRadius
        contentView.addSubview(marketImageView)
        marketImageView.pin(to: wrap)
    }
}
