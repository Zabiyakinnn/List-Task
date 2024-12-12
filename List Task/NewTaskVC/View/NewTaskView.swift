//
//  NewTaskView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 30.11.2024.
//

import UIKit
import SnapKit
import FSCalendar

final class NewTaskView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "TaskVCTableViewColor")
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - View
    //    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = "Новая задача"
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
    
//    текст с именем группы
    lazy var labelNameGroup: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .right
        label.text = "Название группы"
        label.textColor = UIColor.systemYellow
        return label
    }()
    
    //    MARK: - UIButton
    //    кнопка сохранения задачи
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.tintColor = UIColor(named: "ButtonIconeImage")
        return button
    }()
    
//    кнопка открытия календяря
    lazy var buttonDate: UIButton = {
        let button = UIButton(type: .system)
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor(named: "ButtonIconeImage")
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        return button
    }()
    
//    кнопка создания заметки для задачи
    lazy var notionTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor(named: "ButtonIconeImage")
        button.setImage(UIImage(systemName: "list.clipboard"), for: .normal)
        return button
    }()
}

//MARK: - SetupLoyout
extension NewTaskView {
    
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    
    private func prepereView() {
        addSubview(labelHeadline)
        addSubview(textView)
        addSubview(saveButton)
        addSubview(buttonDate)
        addSubview(labelNameGroup)
        addSubview(notionTaskButton)
    }
    
    func updateNameGroup(name: String) {
        labelNameGroup.text = name
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(30)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(210)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(labelHeadline)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        buttonDate.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).inset(-40)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(27)
        }
        labelNameGroup.snp.makeConstraints { make in
            make.centerY.equalTo(notionTaskButton)
            make.right.equalToSuperview().inset(27)
            make.width.equalTo(110)
        }
        notionTaskButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).inset(-39)
            make.left.equalTo(buttonDate.snp.right).offset(15)
            make.height.equalTo(26)
            make.width.equalTo(22)
        }
    }
}
