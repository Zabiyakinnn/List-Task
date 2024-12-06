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
    
    var selectedDate: Date? // выбранная дата
    var dateOFDone: String? // строка для передачи даты на кнопку
    
    var newTask: (() -> Void)? // передача в taskVC
    
    private var newTaskView = NewTaskView()
    private var newTaskProvider = NewTaskProvider()
    
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
        
        calendarDelegate()
        
        setupButton()
        dismissKeyboard()
        
    }
    
    private func setupButton() {
        newTaskView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc func saveButtonTapped() {
        guard let taskText = newTaskView.textView.text, !taskText.isEmpty else {
            print("Task List nil")
            return
        }
        
        guard let nameGroup = nameGroup else {
            print("Не выбранна группа для сохранения задачи")
            return
        }
        
        newTaskProvider.createNewTask(
            name: taskText,
            date: selectedDate,
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

//MARK: - func
extension NewTaskViewController {
    //    скрытие клавиатуры
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
//    calendar Delegate
    private func calendarDelegate() {
        let calendar = newTaskView.calendar
        let selected = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selected
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        newTaskView.textView.endEditing(true)
    }
    
    private func warningText() {
        NotificationUtils.showWarning(on: self, text: "Заполните поле с названием задачи")
    }
}

//MARK: - UICalendarSelectionSingleDateDelegate
extension NewTaskViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dataComponents = dateComponents, let date = dataComponents.date else {
            selectedDate = nil
            dateOFDone = nil
            return
        }
        selectedDate = date
        
        let calendar = newTaskView.calendar
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM"
        
//        родительный падеж
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
        calendar.removeFromSuperview()
    }
}
