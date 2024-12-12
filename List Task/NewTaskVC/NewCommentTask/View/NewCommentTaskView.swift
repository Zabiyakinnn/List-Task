//
//  NewCommentTaskView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 11.12.2024.
//

import UIKit
import SnapKit

final class NewCommentTaskView: UIView {
    
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
        label.text = "Новая заметка"
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
    
    //    MARK: - UIButton
    //    кнопка сохранения комментария
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.tintColor = UIColor(named: "ButtonIconeImage")
        return button
    }()
}

//MARK: - SetupView
extension NewCommentTaskView {
    
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    
    private func prepereView() {
        addSubview(labelHeadline)
        addSubview(saveButton)
        addSubview(textView)
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(30)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(labelHeadline)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(210)
        }
    }
}

