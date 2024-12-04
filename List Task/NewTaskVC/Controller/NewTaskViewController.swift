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
    
    var calendar = UICalendarView()
    var selectedDate: Date?
    var dateOFDone: String?
    
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
        dismissKeyboard()
    }
    
    private func setupButton() {
        newTaskView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        newTaskView.buttonDate.addTarget(self, action: #selector(buttonDateTapped), for: .touchUpInside)
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
        
        guard let date = selectedDate else {
            print("Не выбранна дата задачи")
            return
        }
        
        newTaskProvider.createNewTask(
            name: taskText,
            date: date,
            group: nameGroup) { [weak self] result in
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

    
    @objc func buttonDateTapped() {
        let calendar = newTaskView.calendar
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
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
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        newTaskView.textView.endEditing(true)
    }
    
    private func warningText() {
        NotificationUtils.showWarning(on: self, text: "Заполните поле с названием задачи")
    }
}

extension NewTaskViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dataComponents = dateComponents, let date = dataComponents.date else { return }
        
        selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let selectedDate = dateFormatter.string(from: date)
        
        dateOFDone = selectedDate
        
        newTaskView.buttonDate.setTitle(selectedDate, for: .normal)
        calendar.removeFromSuperview()
    }
}
