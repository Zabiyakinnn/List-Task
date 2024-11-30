//
//  MainView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 29.11.2024.
//

import UIKit
import SnapKit

final class MainView: UIView {
    
//    MARK: - Content
    //    collection
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10 // расстояние между элементами
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 80) // размер элемента
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(GroupCellCollection.self, forCellWithReuseIdentifier: "groupCellCollection")
        collectionView.register(PlaceholderCell.self, forCellWithReuseIdentifier: "PlaceholderCell")
        collectionView.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        return collectionView
    }()
    
    //    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.text = "List Task"
        label.textAlignment = .center
        return label
    }()
    
    //    сегодняшняя дата
    lazy var labelData: UILabel = {
        let label = UILabel()
        let currentData = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        let formatterData = dateFormatter.string(for: currentData)
        label.text = formatterData
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    //    MARK: - Button
    //    кнопка настройки
    lazy var settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        return button
    }()
    
    //    кнопка добавить группу задач
    lazy var newGroupTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - SetupLayout
    private func setupLoyout() {
        backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        
        addSubview(collectionView)
        addSubview(labelHeadline)
        addSubview(labelData)
        addSubview(settingButton)
        addSubview(newGroupTaskButton)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelData.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview()
        }
        labelHeadline.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(66)
            make.left.equalToSuperview().inset(30)
            make.height.equalTo(34)
            make.width.equalTo(150)
        }
        labelData.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(50)
            make.left.equalToSuperview().inset(32)
            make.height.equalTo(20)
        }
        settingButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(60)
            make.height.width.equalTo(40)
        }
        newGroupTaskButton.snp.makeConstraints { make in
            make.right.equalTo(settingButton.snp.right).inset(40)
            make.top.equalToSuperview().inset(60)
            make.height.width.equalTo(40)
        }
    }
}
