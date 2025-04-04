//
//  MoreColorView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 22.03.2025.
//

import UIKit
import SnapKit

final class MoreColorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Content
    //    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont(name: "Bluecurve-Light", size: 20)
        label.text = "Цвета"
        label.textAlignment = .center
        return label
    }()
    
    //    кнопка закрыть viewController
    lazy var closeVCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "ButtonColorBlackAndWhite")
        return button
    }()
    
    //    collectionCell
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let itemCount: CGFloat = 5 // кол-во элементов
        let spacing: CGFloat = 16 // расстояние между элементами
        let totalSpacing = spacing * (itemCount - 1)
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / itemCount
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
}

//MARK: - SetupLoyout
extension MoreColorView {
    private func setupLoyout() {
        addSubview(labelHeadline)
        addSubview(closeVCButton)
        addSubview(collectionView)
        
        setupConstraint()
    }
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeVCButton)
        }
        closeVCButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23)
            make.right.equalToSuperview().inset(30)
            make.height.width.equalTo(30)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(30)
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
