//
//  SettingGroupTaskView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.01.2025.
//

import UIKit
import SnapKit

final class SettingGroupTaskView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupLouoyt()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - ContentView
//    collection Color
    lazy var collectionViewColor: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 46, height: 46)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
//    collection Icon
    lazy var collectionViewIcon: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let itemSize = CGSize(width: 30, height: 30)
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: "iconCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    //    заголовок
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = "Настройки группы"
        label.textAlignment = .center
        return label
    }()
    
//    текст "изменить название"
    private lazy var renameGroupHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Изменить название"
        label.textAlignment = .center
        return label
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
    
//    текст "цвета"
    private lazy var colorHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Цвета"
        label.textAlignment = .center
        return label
    }()
    
//    текст "выберете цвет"
    private lazy var colorChooseHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Выберете цвет для иконки"
        label.textAlignment = .center
        return label
    }()
    
//    текст "Иконки"
    private lazy var iconHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Иконки"
        label.textAlignment = .center
        return label
    }()
    
    //    текст "Изменить иконку"
    private lazy var iconChooseHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Изменить иконку"
        label.textAlignment = .center
        return label
    }()
    
    //    текст "Сортировка задач"
    private lazy var sortingMethod: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Сортировка задач"
        label.textAlignment = .center
        return label
    }()
    
//    кнопка сохранить изменную задачу
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.tintColor = UIColor(named: "ColorTextBlackAndWhite")
        return button
    }()
    
    //    кнопка изменить способ сортировки
    lazy var sortingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("По имени", for: .normal)
        button.tintColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
//    передача данных
    func contentView(name: String) {
        textView.text = name
    }
} 

//MARK: SetupLoyout
extension SettingGroupTaskView {
    private func setupLouoyt() {
        addSubview(labelHeadline)
        addSubview(renameGroupHeadline)
        addSubview(textView)
        addSubview(colorHeadline)
        addSubview(colorChooseHeadline)
        addSubview(collectionViewColor)
        addSubview(iconHeadline)
        addSubview(iconChooseHeadline)
        addSubview(collectionViewIcon)
        addSubview(saveButton)
        addSubview(sortingMethod)
        addSubview(sortingButton)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(30)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(27)
            make.right.equalToSuperview().inset(15)
        }
        renameGroupHeadline.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(50)
            make.left.equalToSuperview().inset(20)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(renameGroupHeadline.snp.top).inset(34)
            make.left.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(14)
            make.height.equalTo(50)
        }
        colorHeadline.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(22)
            make.left.equalToSuperview().inset(20)
        }
        colorChooseHeadline.snp.makeConstraints { make in
            make.top.equalTo(colorHeadline.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        collectionViewColor.snp.makeConstraints { make in
            make.top.equalTo(colorChooseHeadline.snp.bottom).offset(14)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(60)
        }
        iconHeadline.snp.makeConstraints { make in
            make.top.equalTo(collectionViewColor.snp.bottom).offset(18)
            make.left.equalToSuperview().inset(20)
        }
        iconChooseHeadline.snp.makeConstraints { make in
            make.top.equalTo(iconHeadline.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        collectionViewIcon.snp.makeConstraints { make in
            make.top.equalTo(iconChooseHeadline.snp.bottom).offset(18)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(40)
        }
        sortingMethod.snp.makeConstraints { make in
            make.top.equalTo(collectionViewIcon.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
        }
        sortingButton.snp.makeConstraints { make in
            make.centerY.equalTo(sortingMethod)
            make.right.equalToSuperview().offset(-20)
        }
    }
}
