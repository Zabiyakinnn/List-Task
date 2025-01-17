//
//  IconCollectionViewCell.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.11.2024.
//

import UIKit
import SnapKit

final class IconCollectionViewCell: UICollectionViewCell {
    
//    UIImageView icon
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        setupConstraint()
        
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(5)
            make.top.equalTo(contentView.snp.top).inset(5)
            make.width.height.equalTo(26)
        }
    }
    
//    вид ячейки и изображение значка
    func configure(with image: UIImage, isSelected: Bool) {
        iconImageView.image = image
        contentView.layer.borderWidth = isSelected ? 2 : 0
        iconImageView.tintColor = isSelected ? UIColor.systemYellow : UIColor.darkGray
    }
}
