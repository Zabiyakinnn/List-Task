//
//  SettingGroupTaskView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.01.2025.
//

import UIKit
import SnapKit

final class SettingGroupTaskView: UIView {
    
    let colors: [UIColor] = [
        UIColor(red: 0.31, green: 0.38, blue: 0.50, alpha: 1.00),
        UIColor(red: 0.55, green: 0.35, blue: 0.59, alpha: 1.00),
        UIColor(red: 0.22, green: 0.53, blue: 0.64, alpha: 1.00),
        UIColor(red: 0.41, green: 0.07, blue: 0.11, alpha: 1.00),
        UIColor(red: 0.36, green: 0.46, blue: 0.35, alpha: 1.00),
        UIColor(red: 0.90, green: 0.89, blue: 0.29, alpha: 1.00),
        UIColor(red: 0.75, green: 0.49, blue: 0.22, alpha: 1.00),
        UIColor(red: 0.31, green: 0.52, blue: 0.18, alpha: 1.00),
        UIColor(red: 0.34, green: 0.94, blue: 0.84, alpha: 1.00)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupeLouoyt()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - ContentView
//    collection
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 57, height: 57)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = "Настройки группы"
        label.textAlignment = .center
        return label
    }()
    
//    текст "изменить название"
    lazy var renameGroupHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Изменить название"
        label.textAlignment = .center
        return label
    }()
    
//    текст цвета
    lazy var colorHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Цвета"
        label.textAlignment = .center
        return label
    }()
    
//    текст "выберете цвет"
    lazy var colorChooseHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Выберете цвет для иконки"
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
        view.backgroundColor = UIColor.red
        view.tintColor = UIColor(named: "ColorTextBlackAndWhite")
        return view
    }()
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SettingGroupTaskView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        cell.contentView.backgroundColor = colors[indexPath.row]
        cell.contentView.layer.cornerRadius = 28.5
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.row]
        // обработка выбранного цвета
    }
    
}

//MARK: SetupLoyout
extension SettingGroupTaskView {
    private func setupeLouoyt() {
        addSubview(labelHeadline)
        addSubview(renameGroupHeadline)
        addSubview(textView)
        addSubview(colorHeadline)
        addSubview(colorChooseHeadline)
        addSubview(collectionView)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(30)
        }
        renameGroupHeadline.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(50)
            make.left.equalToSuperview().inset(20)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(renameGroupHeadline.snp.top).inset(34)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        colorHeadline.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(22)
            make.left.equalToSuperview().inset(20)
        }
        colorChooseHeadline.snp.makeConstraints { make in
            make.top.equalTo(colorHeadline.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(colorChooseHeadline.snp.bottom).offset(17)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(65)
        }
    }
}
