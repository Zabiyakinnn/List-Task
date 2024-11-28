//
//  NewTaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 07.11.2024.
//

import UIKit
import SnapKit
import CoreData

class NewTaskViewController: UIViewController {
    
    var nameGroup: NameGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        setupLoyout()
    }
    
    //    заголовок
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = "Новый список"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    текст укажите название
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Укажите название"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    поле ввода текста
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //    MARK: - UIButton
    //    кнопка сохранения задачи
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "tray"), for: .normal)
        button.setTitle("Сохранить", for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func saveButtonTapped() {
        guard let taskText = textView.text, !taskText.isEmpty else {
            print("Task List nil")
            return
        }
        CoreDataManagerTaskList.shared.saveNewTaskCoreData(
            nameTask: taskText,
            existingGroup: nameGroup) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
//                    print("Задача \(taskText) сохранена в Core Data")
                    dismiss(animated: true)
                case .failure(let error):
                    print("Ошибка сохранения задачи в CoreData: - \(error.localizedDescription)")
                }
            }
    }
    
//    кнопка выбора даты для задачи
    private lazy var buttonDate: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.addTarget(self, action: #selector(buttonDateTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func buttonDateTapped() {
        let calendar = UICalendarView()
        calendar.calendar = .current
        calendar.locale = .current
        view.addSubview(calendar)
        
        calendar.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
            make.top.equalTo(textView.snp.top).inset(195)
        }
    }
}

// MARK: NewTaskVC
extension NewTaskViewController {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    
    private func prepereView() {
        view.addSubview(labelHeadline)
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(saveButton)
        view.addSubview(buttonDate)
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).inset(17)
            make.top.equalTo(view.snp.top).inset(30)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(48)
            make.left.equalTo(view.snp.left).inset(17)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(78)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
            make.height.equalTo(160)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(20)
            make.right.equalTo(view.snp.right).inset(20)
            make.height.equalTo(40)
        }
        buttonDate.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.top).inset(175)
            make.left.equalTo(view.snp.left).inset(13)
        }
    }
}
