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
    }
//    MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newTaskView.textView.becomeFirstResponder() // открытие клавитуры для textView
    }
    
    private func setupButton() {
        newTaskView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        newTaskView.buttonDate.addTarget(self, action: #selector(buttonDateTapped), for: .touchUpInside)
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
    
//выбор даты
    @objc func buttonDateTapped() {
        newTaskView.textView.endEditing(true)
        if newTaskView.fsCalendar == nil {
            let calendar = FSCalendar()
            calendar.scrollDirection = .horizontal
            calendar.appearance.headerDateFormat = "LLLL"
            calendar.locale = Locale(identifier: "ru_RU")
            calendar.delegate = self
            calendar.dataSource = self
            calendar.layer.cornerRadius = 20
            calendar.backgroundColor = UIColor(named: "ColorCalendar")
            
            calendar.appearance.titleDefaultColor = UIColor(named: "ColorTextBlackAndWhite")
            calendar.appearance.weekdayTextColor = UIColor(named: "ColorTextBlackAndWhite")
            calendar.appearance.titleSelectionColor = UIColor(named: "SelectedDateCalendarColor")
            calendar.appearance.headerTitleColor = UIColor(named: "ColorTextBlackAndWhite")
  
            newTaskView.fsCalendar = calendar
            view.addSubview(calendar)
            
            calendar.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(0)
                make.top.equalTo(newTaskView.buttonDate.snp.bottom).inset(-20)
                make.bottom.equalToSuperview().inset(0)
            }
            calendar.reloadData()
            calendar.setNeedsDisplay()
        } else {
            newTaskView.fsCalendar?.isHidden.toggle()
        }
    }
}

//MARK: - func
extension NewTaskViewController {
    private func warningText() {
        NotificationUtils.showWarning(on: self, text: "Заполните поле с названием задачи")
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
        calendar.removeFromSuperview()
        newTaskView.textView.becomeFirstResponder()
        newTaskView.fsCalendar = nil
    }
}
