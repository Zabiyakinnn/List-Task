//
//  ColorCell.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.01.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
//    цвет
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()
    
//    галочка выбранного цвета
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(colorView)
        addSubview(checkmarkImageView)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        colorView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
        }
        checkmarkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(22)
        }
    }
    
    func configure(with color: UIColor, isSilected: Bool) {
        colorView.backgroundColor = color
//        галочка выбранного цвета
        checkmarkImageView.isHidden = !isSilected
    }
}
