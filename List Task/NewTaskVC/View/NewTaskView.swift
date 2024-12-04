//
//  NewTaskView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 30.11.2024.
//

import UIKit
import SnapKit

final class NewTaskView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = "Новая задача"
        label.textAlignment = .center
        return label
    }()
    
    //    текст укажите название
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Укажите название"
        label.textAlignment = .center
        return label
    }()
    
    //    поле ввода текста
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    //    календарь
    lazy var calendar: UICalendarView = {
        let calendar = UICalendarView()
        calendar.calendar = .current
        calendar.locale = .current
        addSubview(calendar)
        
        calendar.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(textView.snp.top).inset(195)
        }
        
        return calendar
    }()
    
    //    MARK: - UIButton
    //    кнопка сохранения задачи
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "tray"), for: .normal)
        button.setTitle("Сохранить", for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        return button
    }()
    
//    кнопка открытия календяря
    lazy var buttonDate: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        return button
    }()
}

extension NewTaskView {
    
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    
    private func prepereView() {
        addSubview(labelHeadline)
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(saveButton)
        addSubview(buttonDate)
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(17)
            make.top.equalToSuperview().inset(30)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(48)
            make.left.equalToSuperview().inset(17)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(78)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        buttonDate.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.top).inset(175)
            make.left.equalToSuperview().inset(13)
        }
    }
}
