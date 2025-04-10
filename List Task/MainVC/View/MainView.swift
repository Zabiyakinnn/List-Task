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
        collectionView.backgroundColor = UIColor(named: "ColorViewBlackAndWhite")
        return collectionView
    }()
    
    //    сегодняшний день недели
    lazy var labelDayWeek: UILabel = {
        let label = UILabel()
        let currentData = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        var formatterData = dateFormatter.string(for: currentData)
        label.text = formatterData
        label.font = UIFont(name: "Bluecurve-Light", size: 21)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        return label
    }()
    
//    сегодняшняя дата
    lazy var labelDate: UILabel = {
        let label = UILabel()
        let currentData = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        var formatterData = dateFormatter.string(for: currentData)
        label.text = formatterData
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont(name: "Bluecurve-Bold", size: 26)
        label.textAlignment = .left
        return label
    }()
    
    //    MARK: - Button
    //    кнопка добавить группу задач
    lazy var newGroupTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
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
        backgroundColor = .systemBackground
        
        addSubview(collectionView)
        addSubview(labelDayWeek)
        addSubview(labelDate)
        addSubview(newGroupTaskButton)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelDayWeek.snp.top).offset(75)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview()
        }
        labelDayWeek.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.left.equalToSuperview().inset(23)
            make.height.equalTo(20)
        }
        labelDate.snp.makeConstraints { make in
            make.top.equalTo(labelDayWeek.snp.bottom).inset(-10)
            make.left.equalToSuperview().inset(23)
        }
        newGroupTaskButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(60)
            make.height.width.equalTo(40)
        }
    }
}
