//
//  TaskCellTableView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 25.11.2024.
//

import UIKit
import SnapKit

final class TaskCell: UITableViewCell {
    
    let formatter = DateFormatter()
    var onConditionButtonStatus: ((Bool) -> Void)?
    
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
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    //    дата задачи
    private lazy var dateTask: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    //    MARK: - UIButton
    //    кнопка изменения задачи выполненно/не выполненно
    private lazy var conditionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "app"), for: .normal)
        button.setImage(UIImage(systemName: "xmark.app"), for: .selected)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.3)
        button.imageView?.contentMode = .scaleAspectFit
//        button.tintColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        button.addTarget(self, action: #selector(conditionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func conditionButtonTapped() {
        conditionButton.isSelected.toggle()
        onConditionButtonStatus?(conditionButton.isSelected)
    }
    
    func configure(_ taskList: TaskList) {
        nameTask.text = taskList.nameTask
        conditionButton.isSelected = taskList.completed
        updateConditionButtonApperance()
        
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        dateTask.text = dateFormmater(for: taskList.date)
        
    }
    
//    настройка цвета кнопки в зависимости от состояния
    private func updateConditionButtonApperance() {
        if conditionButton.isSelected {
            conditionButton.tintColor = UIColor.systemRed
        } else {
            conditionButton.tintColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        }
    }
    
//    dateFormatter
    private func dateFormmater(for date: Date?) -> String? {
        guard let date = date else { return nil }
        
        switch true {
        case Calendar.current.isDateInToday(date):
            return "Сегодня"
        case Calendar.current.isDateInYesterday(date):
            return "Вчера"
        case Calendar.current.isDateInTomorrow(date):
            return "Завтра"
        default:
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM"
            return formatter.string(from: date)
        }
    }
}

//MARK: - TaskCell setup
extension TaskCell {
    private func setupeLoyout() {
        prepereView()
        setupConstraint()
        contentView.backgroundColor = UIColor(named: "ColorViewBlackAndWhite")
        
    }
    
    private func prepereView() {
        contentView.addSubview(nameTask)
        contentView.addSubview(conditionButton)
        contentView.addSubview(dateTask)
    }
    
    private func setupConstraint() {
        conditionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.left).inset(8)
            make.width.height.equalTo(40)
        }
        nameTask.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(17)
            make.left.equalTo(conditionButton.snp.left).inset(45)
            make.right.equalTo(contentView.snp.right).inset(22)
        }
        dateTask.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(13)
            make.top.equalTo(nameTask.snp.bottom).inset(-7)
            make.left.equalTo(conditionButton.snp.left).inset(45)
        }
    }
}
