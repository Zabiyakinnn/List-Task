//
//  NewGroupView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 29.11.2024.
//

import UIKit
import SnapKit

class NewGroupView: UIView {
    
    //    MARK: - Content
    //    collectionIcon
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let itemCount: CGFloat = 5 // кол-во элементов
        let spacing: CGFloat = 16 // расстояние между элементами
        let totalSpacing = spacing * (itemCount - 1)
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / itemCount
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: "iconCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    //    поле ввода текста
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont(name: "Bluecurve-Bold", size: 21)
        view.textColor = UIColor(named: "ColorTextBlackAndWhite")
        view.backgroundColor = UIColor.clear
        view.tintColor = UIColor(named: "ColorTextBlackAndWhite")
        return view
    }()
    
    //    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont(name: "Bluecurve-Light", size: 20)
        label.text = "Новый список"
        label.textAlignment = .center
        return label
    }()
    
//    текст "выберете иконку"
    lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont(name: "Bluecurve-Light", size: 18)
        label.text = "Выберете иконку"
        label.textAlignment = .center
        return label
    }()
    
    //    текст "укажите название"
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont(name: "Bluecurve-Light", size: 18)
        label.text = "Укажите название"
        label.textAlignment = .center
        return label
    }()
    
    //    MARK: - UIButton
    //    кнопка сохранения
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Bluecurve-Light", size: 16)
        button.tintColor = UIColor(named: "ColorTextBlackAndWhite")
        return button
    }()
    
//    открыть доп экран с икнонками для задач
    lazy var moreIconsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Еще", for: .normal)
        button.titleLabel?.font = UIFont(name: "Bluecurve-Light", size: 16)
        button.tintColor = UIColor.lightGray
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "TaskVCTableViewColor")

        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: SetupLoyout
extension NewGroupView {
    private func setupLoyout() {
        addSubview(labelHeadline)
        addSubview(saveButton)
        addSubview(textView)
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(iconLabel)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(30)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(78)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(48)
            make.left.equalToSuperview().inset(17)
        }
        iconLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.top).inset(60)
            make.left.equalToSuperview().inset(17)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.top).inset(40)
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
    }
}
