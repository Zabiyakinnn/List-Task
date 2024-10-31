//
//  TaskCellCollection.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 31.10.2024.
//

import UIKit
import SnapKit

final class TaskCellCollection: UICollectionViewCell {
    
    private lazy var nameTask: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ todoItem: Todos) {
        nameTask.text = todoItem.name
        taskCountLabel.text = "Кол-во задач\(todoItem.countTask)"
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
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(red: 0.61, green: 0.66, blue: 0.67, alpha: 1.00)
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
            make.top.equalTo(contentView.snp.top).inset(18)
        }
        taskCountLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(26)
            make.top.equalTo(nameTask.snp.top).inset(30)
        }
    }
}
