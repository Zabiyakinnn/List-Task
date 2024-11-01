//
//  TaskCellCollection.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 31.10.2024.
//

import UIKit
import SnapKit

final class TaskCellCollection: UICollectionViewCell {
    
//    имя задачи
    private lazy var nameTask: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
//    кол-во задач
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
//    удаление ячейки с азадачами
    private lazy var trashButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ todoItem: NameGroup) {
        nameTask.text = todoItem.name
    }
    
    @objc func trashButtonTapped() {
        print("Trash tapped")
    }
}

//MARK: - TaskCellCollection Methods
private extension TaskCellCollection {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
        configureUI()

    }
    
    func prepereView() {
        contentView.addSubview(nameTask)
        contentView.addSubview(taskCountLabel)
        contentView.addSubview(trashButton)
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.91, alpha: 1.00)
        contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    private func setupConstraint() {
        nameTask.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(15)
            make.centerY.equalToSuperview()
        }
        taskCountLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(26)
            make.top.equalTo(nameTask.snp.top).inset(30)
        }
        trashButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).inset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }
    }
}
