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
        backgroundColor = UIColor.systemBackground
        
        keyboardLayoutGuide.followsUndockedKeyboard = true
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
        label.font = UIFont(name: "Bluecurve-Light", size: 19)
        label.textAlignment = .center
        return label
    }()
    
    //    поле ввода текста
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont(name: "Bluecurve-Bold", size: 21)
        view.textColor = UIColor(named: "ColorTextBlackAndWhite")
        view.backgroundColor = UIColor.clear
        view.tintColor = UIColor(named: "ColorTextBlackAndWhite")
        return view
    }()
    
//    текст с именем группы
    lazy var labelNameGroup: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Bluecurve-Bold", size: 21)
        label.textAlignment = .right
        label.text = "Название группы"
        label.textColor = UIColor.systemYellow
        return label
    }()
    
    private lazy var seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    //    MARK: - UIButton
    //    кнопка сохранения задачи
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Bluecurve-Light", size: 18)
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
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "list.clipboard")
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        configuration.preferredSymbolConfigurationForImage = imageConfig
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.tintColor = UIColor(named: "ButtonIconeImage")
        return button
    }()
    
//    кнопка установки приоретета для задачи
    lazy var priorityButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "flag")

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        configuration.preferredSymbolConfigurationForImage = imageConfig
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor(named: "ButtonIconeImage")
        return button
    }()
    
    func content(nameTask: String) {
        textView.text = nameTask
    }
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
        addSubview(priorityButton)
        addSubview(seperatorLine)
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
            make.height.equalTo(290)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(labelHeadline)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        buttonDate.snp.makeConstraints { make in
            make.bottom.equalTo(seperatorLine.snp.top).offset(-1)
            make.left.equalTo(seperatorLine.snp.left).offset(20)
            make.height.equalTo(25)
        }
        labelNameGroup.snp.makeConstraints { make in
            make.bottom.equalTo(seperatorLine.snp.top).offset(0)
            make.right.equalTo(seperatorLine.snp.right).inset(27)
            make.width.equalTo(110)
        }
        notionTaskButton.snp.makeConstraints { make in
            make.bottom.equalTo(seperatorLine.snp.top).inset(0)
            make.left.equalTo(buttonDate.snp.right).offset(15)
            make.height.equalTo(28)
            make.width.equalTo(28)

        }
        priorityButton.snp.makeConstraints { make in
            make.centerY.equalTo(buttonDate)
            make.left.equalTo(notionTaskButton.snp.right).offset(15)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        seperatorLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let seperatorLineOnKeyboard = keyboardLayoutGuide.topAnchor.constraint(equalTo: seperatorLine.bottomAnchor, constant: 0)
        keyboardLayoutGuide.setConstraints([seperatorLineOnKeyboard], activeWhenAwayFrom: .top)
    }
}
