//
//  TaskCellTableView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 25.11.2024.
//

import UIKit
import SnapKit

final class TaskCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupeLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - View
//    имя задачи
    private lazy var nameTask: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    //    MARK: - UIButton
    //    кнопка изменения задачи выполненно/не выполненно
    private lazy var conditionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(conditionButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func conditionButtonTapped() {
        print("condition button tapped")
    }
    
    func configure(_ taskList: TaskList) {
        nameTask.text = taskList.nameTask
    }
}

//MARK: - TaskCell setup
extension TaskCell {
    private func setupeLoyout() {
        prepereView()
        setupConstraint()
        contentView.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.91, alpha: 1.00)
    }
    
    private func prepereView() {
        contentView.addSubview(nameTask)
        contentView.addSubview(conditionButton)
    }
    
    private func setupConstraint() {
        conditionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.left).inset(8)
            make.width.height.equalTo(40)
        }
        nameTask.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(11)
            make.left.equalTo(conditionButton.snp.left).inset(45)
        }
    }
}
