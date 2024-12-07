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
        let itemSize = CGSize(width: 30, height: 30)
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: "iconCollectionViewCell")
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    //    поле ввода текста
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 21)
        view.textColor = UIColor(named: "ColorTextBlackAndWhite")
        view.backgroundColor = UIColor.clear
        view.tintColor = UIColor(named: "ColorTextBlackAndWhite")
        return view
    }()
    
    //    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = "Новый список"
        label.textAlignment = .center
        return label
    }()
    
    //    текст "выберете иконку"
    lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Выберете иконку"
        label.textAlignment = .center
        return label
    }()
    
    //    текст укажите название
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Укажите название"
        label.textAlignment = .center
        return label
    }()
    
    //    MARK: - UIButton
    //    кнопка сохранения
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.tintColor = UIColor(named: "ColorTextBlackAndWhite")
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "ColorViewBlackAndWhite")

        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLoyout() {
        addSubview(labelHeadline)
        addSubview(saveButton)
        addSubview(textView)
        addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(collectionView)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(17)
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
            make.height.equalTo(50)
        }
    }
}
