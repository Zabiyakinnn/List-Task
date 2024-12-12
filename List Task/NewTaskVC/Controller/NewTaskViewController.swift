//
//  NewTaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 07.11.2024.
//

import UIKit
import SnapKit
import CoreData
import FSCalendar

class NewTaskViewController: UIViewController {
    
    var nameGroup: NameGroup?
    
    var selectedDate: Date? // выбранная дата
    var dateOFDone: String? // строка для передачи даты на кнопку
    
    var newTask: (() -> Void)? // передача в taskVC
    
    private var newTaskView = NewTaskView()
    private var newTaskProvider = NewTaskProvider()
    let newCommentTaskVC = NewCommentTaskViewController()
    
    //    MARK: Init
    init(nameGroup: NameGroup, provider: NewTaskProvider = NewTaskProvider()) {
        super.init(nibName: nil, bundle: nil)
        self.nameGroup = nameGroup
        self.newTaskProvider = provider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - LoadView
    override func loadView() {
        self.view = newTaskView
    }
    
    //    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupLoyout()
        newTaskView.textView.delegate = self

    }
    //    MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newTaskView.textView.becomeFirstResponder() // открытие клавитуры для textView
    }
    
    private func setupButton() {
        newTaskView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        newTaskView.buttonDate.addTarget(self, action: #selector(buttonDateTapped), for: .touchUpInside)
        newTaskView.notionTaskButton.addTarget(self, action: #selector(notionTaskButtonTapped), for: .touchUpInside)
    }
    
    //    MARK: ButtonTapped
    //    сохранение задачи
    @objc func saveButtonTapped() {
        
        guard let taskText = newTaskView.textView.text, !taskText.isEmpty else {
            print("Task List nil")
            return
        }
        
        guard let nameGroup = nameGroup else {
            print("Не выбранна группа для сохранения задачи")
            return
        }
        
        if let commentTask = newCommentTaskVC.newCommentTaskView.textView.text {
            newTaskProvider.createNewTask(
                name: taskText,
                date: selectedDate,
                notionTask: commentTask,
                group: nameGroup,
                statusTask: false) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success():
                        print("Задача сохранена в CoreData")
                        self.newTask?()
                        dismiss(animated: true)
                    case .failure(let error):
                        print("Ошибка сохранения задачи в CoreData: - \(error.localizedDescription)")
                    }
                }
        }
    }
    
    //выбор даты
    @objc func buttonDateTapped() {
        newTaskView.textView.endEditing(true)
        
        if let existinCalendarView = view.subviews.first(where: { $0 is CalendarPickerView }) as? CalendarPickerView {
            existinCalendarView.removeFromSuperview() // убираем календарь если он отображен
            newTaskView.textView.becomeFirstResponder()
        } else {
            let calendarView = CalendarPickerView()
            calendarView.calendar.delegate = self
            calendarView.calendar.dataSource = self
            view.addSubview(calendarView)
            
            calendarView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(view.frame.height / 2)
                make.bottom.equalToSuperview()
            }
        }
    }
    
//    переход на newCommentTaskViewController
    @objc func notionTaskButtonTapped() {
        self.present(newCommentTaskVC, animated: true)
        
        newCommentTaskVC.onColorIconComment = { [weak self] hasText in
            guard let self = self else { return }
            newTaskView.notionTaskButton.tintColor = hasText ? UIColor.systemYellow : UIColor(named: "ButtonIconeImage")
        }
    }
}

//MARK: - func
extension NewTaskViewController {
    private func setupLoyout() {
        setupNameGroupText()
    }
    
    private func warningText() {
        NotificationUtils.showWarning(on: self, text: "Заполните поле с названием задачи")
    }
    
    private func setupNameGroupText() {
        newTaskView.updateNameGroup(name: nameGroup?.name ?? "Название группы")
    }
}

//MARK: - UITextViewDelegate (скрыть календарь при открытой клавитуре в textView)
extension NewTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let calendarView = view.subviews.first(where: { $0 is CalendarPickerView }) {
            calendarView.removeFromSuperview()
        }
    }
}

//MARK: - FSCalendarDelegate, FSCalendarDataSource
extension NewTaskViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM"
        
        // родительный падеж
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.locale = Locale(identifier: "ru_RU_POSIX")
        dateFormatter.calendar = customCalendar
        
        let today = Calendar.current.startOfDay(for: Date()) // сегодняшняя дата
        let selectedDay = Calendar.current.startOfDay(for: date) // выбранная дата
        let difference = Calendar.current.dateComponents([.day], from: today, to: selectedDay).day
        
        var selectedDateString: String
        
        switch difference {
        case 0:
            selectedDateString = "Сегодня"
        case 1:
            selectedDateString = "Завтра"
        case -1:
            selectedDateString = "Вчера"
        default:
            selectedDateString = dateFormatter.string(from: date)
        }
        
        dateOFDone = selectedDateString
        newTaskView.buttonDate.setTitle(selectedDateString, for: .normal)
        newTaskView.buttonDate.setImage(nil, for: .normal)
        newTaskView.buttonDate.tintColor = UIColor(named: "SelectedDateCalendarColor")
        
        if let calendarView = view.subviews.first(where: { $0 is CalendarPickerView }) {
            calendarView.removeFromSuperview()
        }
        newTaskView.textView.becomeFirstResponder()
    }
}
