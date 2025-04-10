//
//  CategoryCell.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 21.03.2025.
//
import UIKit

class FavoriteMarketCell: UICollectionViewCell {
    
    //MARK: - Constants
    enum Constants {
        enum Wrap {
            static let bottomConstraint: CGFloat = 48
        }
        enum TitleLabel {
            static let font: UIFont = .systemFont(ofSize: 25, weight: .medium)
            static let textAlignment: NSTextAlignment = .center
        }
        enum ImageView {
            static let clipsToBounds: Bool = true
            static let contentMode: UIView.ContentMode = .scaleAspectFit
            static let cornerRadius: CGFloat = 16
        }
    }
    
    //MARK: - Variables
    static let reuseIdentifier = "FavoriteMarketCell"
    private let imageView: UIImageView = UIImageView()
    private let wrap: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    
    //MARK: - Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure(market: Market) {
        titleLabel.text = market.title
        imageView.image = UIImage(named: market.image)
        configureWrap()
        configureImageView()
        configureTitleLabel()
    }
    
    private func configureWrap() {
        wrap.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        contentView.addSubview(wrap)
        wrap.pinTop(to: contentView)
        wrap.pinHorizontal(to: contentView)
        wrap.pinBottom(to: contentView, Constants.Wrap.bottomConstraint)
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        titleLabel.font = Constants.TitleLabel.font
        titleLabel.textAlignment = Constants.TitleLabel.textAlignment
        contentView.addSubview(titleLabel)
        titleLabel.pinTop(to: wrap.bottomAnchor)
        titleLabel.pinBottom(to: contentView)
        titleLabel.pinHorizontal(to: contentView)
    }
    
     private func configureImageView() {
         imageView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
         imageView.clipsToBounds = Constants.ImageView.clipsToBounds
         imageView.contentMode = Constants.ImageView.contentMode
         imageView.layer.cornerRadius = Constants.ImageView.cornerRadius
        contentView.addSubview(imageView)
         imageView.pin(to: wrap)
    }
}
