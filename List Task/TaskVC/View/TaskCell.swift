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
        label.font = UIFont(name: "Bluecurve-Bold", size: 17)
        label.textColor = .black
        return label
    }()
    
    //    дата задачи
    private lazy var dateTask: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Bluecurve-Light", size: 13)

        label.textColor = UIColor.lightGray
        return label
    }()
    
//    иконка заметки(если она есть)
    private lazy var iconNotionTask: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //    MARK: - UIButton
    //    кнопка изменения задачи выполненно/не выполненно
    private lazy var conditionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "app"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .selected)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1)
        button.imageView?.contentMode = .scaleAspectFit
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

        if let textNotion = taskList.notionTask, !textNotion.isEmpty {
            if iconNotionTask.superview == nil { //если иконка не добавленна
                contentView.addSubview(iconNotionTask)
            }
            iconNotionTask.image = UIImage(systemName: "list.clipboard")
            iconNotionTask.tintColor = UIColor.systemOrange
        } else {
            iconNotionTask.removeFromSuperview()
        }
        
        updateTextTask(isCompleted: taskList.completed)
        
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        dateTask.text = dateFormmater(for: taskList.date)
        
        remakeConstraints()
    }
    
//    изменение цвета кнопки 
        func colorConditionButton(taskList: TaskList) {
        if conditionButton.isSelected {
            conditionButton.tintColor = UIColor.systemGreen // цвет кнопки в зависимисти от состояни задачи (выполненно/ не выполненно)
        } else {
            switch taskList.priority { // цвет кнопки в зависимости от выставленного приоритета
            case 1:
                conditionButton.tintColor = UIColor.systemGreen
            case 2:
                conditionButton.tintColor = UIColor.systemOrange
            case 3:
                conditionButton.tintColor = UIColor.systemRed
            default:
                conditionButton.tintColor = UIColor(named: "ButtonIconeImage")
            }
        }
    }
    
//    метод пересчета констрейнов для notionTask
    private func remakeConstraints() {
        guard iconNotionTask.superview != nil else { return }
        
        iconNotionTask.snp.remakeConstraints() { make in
            make.bottom.equalToSuperview().inset(12)
            make.centerY.equalTo(dateTask)
            make.width.height.equalTo(12)
            
            if let dateText = dateTask.text, !dateText.isEmpty {
                make.left.equalTo(dateTask.snp.right).offset(8)
            } else {
                make.left.equalTo(conditionButton.snp.left).inset(44)
            }
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
    
//    обновление текста в зависимости от статуса задачи(выполненно/не выполненно)
    private func updateTextTask(isCompleted: Bool) {
        if isCompleted {
//            задача завершена
            let atributtedString = NSAttributedString(
                string: nameTask.text ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.darkGray
                ]
            )
            nameTask.attributedText = atributtedString
        } else {
//            задача не завершенна
            let atributtedString = NSAttributedString(
                string: nameTask.text ?? "",
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: UIColor(named: "ColorTextBlackAndWhite") ?? UIColor.darkGray
                ]
            )
            nameTask.attributedText = atributtedString
        }
    }
}

//MARK: - TaskCell setup
extension TaskCell {
    private func setupeLoyout() {
        prepereView()
        setupConstraint()
        contentView.backgroundColor = .systemBackground
        
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
            make.width.height.equalTo(30)
        }
        nameTask.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(12)
            make.left.equalTo(conditionButton.snp.left).inset(45)
            make.right.equalTo(contentView.snp.right).inset(22)
        }
        dateTask.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(9)
            make.top.equalTo(nameTask.snp.bottom).inset(-7)
            make.left.equalTo(conditionButton.snp.left).inset(45)
        }
    }
}
