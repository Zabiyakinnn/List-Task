//
//  GroupCellCollection.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 31.10.2024.
//

import UIKit
import SnapKit
import CoreData

final class GroupCellCollection: UICollectionViewCell {
    
//    замыкание для удаления ячейки
    var onDelete: (() -> Void)?

//    имя задачи
    private lazy var nameTask: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        return label
    }()
    
//    кол-во задач
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
//    кнопка удаление ячейки с задачами
    private lazy var trashButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        button.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        return button
    }()
    
//  iconImage
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
//    линия для разделения ячейки
    private lazy var seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ nameGroup: NameGroup,_ taskCount: Int) {
        nameTask.text = nameGroup.name
        taskCountLabel.text = "Кол-во задач \(taskCount)"
        if let iconData = nameGroup.iconNameGroup,
           let iconImage = UIImage(data: iconData)?.withRenderingMode(.alwaysTemplate) {
            iconImageView.image = iconImage
//            iconImageView.tintColor = UIColor(named: "ButtonIconeImage")
            
            let colorIndex = Int(nameGroup.colorIcon)
//            если индекс находится в пределах массива
            if colorIndex >= 0 && colorIndex < ColorPalette.colors.count {
                let selectedColor = ColorPalette.colors[colorIndex]
                applyColorToIcon(selectedColor)
            } else {
//                индекс не валиден
                applyColorToIcon(UIColor(named: "ButtonIconeImage") ?? .lightGray)
            }
        }
    }
    
//    применение цвета к иконке
    func applyColorToIcon(_ color: UIColor) {
        iconImageView.tintColor = color
    }
    
    @objc func trashButtonTapped() {
        onDelete?() //вызов замыкания при нажатии на кнопку "trashButton"
    }
}

//MARK: - TaskCellCollection Methods
private extension GroupCellCollection {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
        configureUI()
    }
    
    func prepereView() {
        contentView.addSubview(nameTask)
        contentView.addSubview(taskCountLabel)
        contentView.addSubview(trashButton)
        contentView.addSubview(iconImageView)
        contentView.addSubview(seperatorLine)
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(named: "CollectionViewBackgroundColor")
        contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    private func setupConstraint() {
        nameTask.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.left).inset(45)
            make.right.equalTo(trashButton.snp.right).inset(35)
            make.top.equalTo(contentView.snp.top).inset(12)
        }
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(13)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
        taskCountLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.left).inset(44)
            make.top.equalTo(seperatorLine.snp.top).inset(7)
        }
        trashButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).inset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(26)
        }
        seperatorLine.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.left).inset(33)
            make.right.equalTo(trashButton.snp.right).inset(30)
            make.centerY.equalToSuperview()
            make.height.equalTo(1.5)
        }
    }
}
