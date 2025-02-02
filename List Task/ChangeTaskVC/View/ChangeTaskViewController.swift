//
//  ChangeTaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 30.01.2025.
//

import UIKit
import FSCalendar

final class ChangeTaskViewController: UIViewController {
    
    private var changeView = NewTaskView() //ContentView
    private var viewModel: ChangeTaskViewModel // viewModel
    
    private let newCommentTaskVC = NewCommentTaskViewController()
    private let calendarView = CalendarPickerView()
    private let priorityView = PriorityView()
    
    private var selectedDate: Date?
    
    init(viewModel: ChangeTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - LoadView
    override func loadView() {
        self.view = changeView
    }
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupActions()
        buttonColor()
    }
    
    //    MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeView.textView.becomeFirstResponder() // открытие клавитуры для textView
    }
    
//    MARK: SetupButton
    private func setupActions() {
        changeView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        changeView.notionTaskButton.addTarget(self, action: #selector(notionTaskButtonTapped), for: .touchUpInside)
        changeView.priorityButton.addTarget(self, action: #selector(priorityButtonTapped), for: .touchUpInside)
        changeView.buttonDate.addTarget(self, action: #selector(buttonDateTapped), for: .touchUpInside)
    }
    
//    настройка цвета кнопки
    private func buttonColor() {
        if let textNotion = viewModel.taskList.notionTask {
            newCommentTaskVC.newCommentTaskView.textView.text = textNotion
            changeView.notionTaskButton.tintColor = UIColor.systemYellow
        } else {
            changeView.notionTaskButton.tintColor = UIColor(named: "ButtonIconeImage")
        }
        //        кнопка выбора приоритета
        let priorityTask = viewModel.taskList.priority
        switch priorityTask {
        case 1:
            changeView.priorityButton.tintColor = UIColor.systemGreen
        case 2:
            changeView.priorityButton.tintColor = UIColor.systemOrange
        case 3:
            changeView.priorityButton.tintColor = UIColor.systemRed
        default:
            changeView.priorityButton.tintColor = UIColor(named: "ButtonIconeImage")
        }
    }
    
//    setupeUI
    private func setupUI() {
        changeView.labelHeadline.text = "Редактировать задачу" // заголовок
        changeView.labelNameGroup.text = viewModel.nameGroup.name // группа задачи
        changeView.textView.text = viewModel.taskList.nameTask // текст с именем задачи
        
//        настройка кнопки с датой
        if let dateTask = viewModel.taskList.date {
            selectedDate = dateTask
            let date = viewModel.formatterDate(date: dateTask)
            changeView.buttonDate.setTitle(date, for: .normal)
            changeView.buttonDate.setImage(nil, for: .normal)
            changeView.buttonDate.tintColor = UIColor(named: "SelectedDateCalendarColor")
        } else {
            changeView.buttonDate.setTitle(nil, for: .normal)
            changeView.buttonDate.setImage(UIImage(systemName: "calendar"), for: .normal)
        }
    }
    
//    настройка привязок
    private func setupBinding() {
        viewModel.onDateUpdated = { [weak self] formatterDate in
            guard let self = self else { return }
            changeView.buttonDate.setTitle(formatterDate, for: .normal)
            changeView.buttonDate.setImage(nil, for: .normal)
            changeView.buttonDate.tintColor = UIColor(named: "SelectedDateCalendarColor")
        }
    }
    
    // сохарнить задачу
    @objc private func saveButtonTapped() {
        let nameTaskText = changeView.textView.text // текст задачи
        
        let commentTask = newCommentTaskVC.newCommentTaskView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if commentTask.isEmpty {
            viewModel.commentTask = nil // если комментарий не введен то nil
        } else {
            viewModel.commentTask = commentTask // введенный комментарий 
        }

        if let selectedDate = viewModel.selectedDate {
            viewModel.selectedDate = selectedDate // если выбранна дата
        } else {
            let dateTask = viewModel.taskList.date
            viewModel.selectedDate = dateTask // дата из CoreData
        }
        
        if let selectedPriority = viewModel.priorityTask {
            viewModel.priorityTask = selectedPriority // если выбран приоритет
        } else {
            let priorityTask = viewModel.taskList.priority
            viewModel.priorityTask = Int(priorityTask) // приоритет из CoreData
        }
        
        viewModel.changeSaveTask(nameTask: nameTaskText)
        dismiss(animated: true)
    }
    
    //переход на экран для комментария к задаче
    @objc private func notionTaskButtonTapped() {
        self.present(newCommentTaskVC, animated: true)
        
        newCommentTaskVC.onColorIconComment = { [weak self] hasText in
            guard let self = self else { return }
            viewModel.commentTask = newCommentTaskVC.newCommentTaskView.textView.text  // текст заметки из newCommentTaskVC
            changeView.notionTaskButton.tintColor = hasText ? UIColor.systemYellow : UIColor(named: "ButtonIconeImage")
        }
    }
    
//    открыть календарь для выбора даты
    @objc private func buttonDateTapped() {
            changeView.textView.endEditing(true)
        
        if let existingCalendarView = self.view.subviews.first(where: { $0.tag == 1001 }) as? CalendarPickerView {
            existingCalendarView.hide {
                self.view.subviews.first(where: { $0.tag == 999 })?.removeFromSuperview()
            }
        } else {
            // затемненный фон
            let overlayView = UIView()
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            overlayView.tag = 999 // Уникальный тег для последующего удаления
            overlayView.frame = self.view.bounds
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeCalendar))
            overlayView.addGestureRecognizer(tapGesture)
            self.view.addSubview(overlayView)
            
            calendarView.tag = 1001
            calendarView.calendar.delegate = self
            calendarView.calendar.dataSource = self
            calendarView.show(in: self.view)
            
            if var selectedDate = selectedDate {
                calendarView.calendar.select(selectedDate)
                if let dateTapped = viewModel.selectedDate {
                    selectedDate = dateTapped
                    calendarView.calendar.select(dateTapped)
                }
            }

            UIView.animate(withDuration: 0.3, animations: {
                overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            })
        }
    }
    
//    закрыть календарь
    @objc private func closeCalendar() {
        if let calendarView = self.view.subviews.first(where: { $0.tag == 1001 }) as? CalendarPickerView,
           let overlayView = self.view.subviews.first(where: { $0.tag == 999 }) {
            calendarView.hide()
            
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
        changeView.textView.becomeFirstResponder()
    }
    
    //открыть view с выбором приоритета
    @objc private func priorityButtonTapped() {
        changeView.textView.endEditing(true)
        
        if let existingPriorityView = self.view.subviews.first(where: { $0.tag == 1002}) as? PriorityView {
            existingPriorityView.hide {
                self.view.subviews.first(where: { $0.tag == 888})?.removeFromSuperview()
            }
        } else {
            // затемненный фон
            let overlayView = UIView()
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            overlayView.tag = 888 // Уникальный тег для последующего удаления
            overlayView.frame = self.view.bounds
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePriorityView))
            overlayView.addGestureRecognizer(tapGesture)
            self.view.addSubview(overlayView)
            
            priorityView.tag = 1002
//            priorityView.initialSelectedPriority = viewModel.priorityTask ?? 0
            priorityView.initialSelectedPriority = Int(viewModel.taskList.priority)
            priorityView.show(in: self.view)

            priorityView.onPrioritySelected = { [weak self] index in
                guard let self = self else { return }
                self.viewModel.priorityTask = index
                
                switch index {
                case 1:
                    changeView.priorityButton.tintColor = UIColor.systemGreen
                case 2:
                    changeView.priorityButton.tintColor = UIColor.systemOrange
                case 3:
                    changeView.priorityButton.tintColor = UIColor.systemRed
                default:
                    changeView.priorityButton.tintColor = UIColor(named: "ButtonIconeImage")
                }
                
                // Убираем затемнение и PriorityView
                if let overlayView = self.view.subviews.first(where: { $0.tag == 888 }) {
                    UIView.animate(withDuration: 0.3, animations: {
                        overlayView.alpha = 0
                    }) { _ in
                        overlayView.removeFromSuperview()
                    }
                }
                self.changeView.textView.becomeFirstResponder()
            }
                        
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            })
        }
    }
    //    закрыть PriorityView
    @objc private func closePriorityView() {
        if let priorityView = self.view.subviews.first(where: { $0.tag == 1002 }) as? PriorityView,
           let overlayView = self.view.subviews.first(where: { $0.tag == 888 }) {
            priorityView.hide()
            
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
        changeView.textView.becomeFirstResponder()
    }
}

//MARK: - UITextViewDelegate
//скрыть view при открытой клавитуре textView
extension ChangeTaskViewController: UITextViewDelegate {
//    календарь
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let calendarView = self.view.subviews.first(where: { $0.tag == 1001 }) as? CalendarPickerView,
           let overlayView = self.view.subviews.first(where: { $0.tag == 999 }) {
            calendarView.removeFromSuperview()
            overlayView.removeFromSuperview()
        }
//        view с выбором приоритета
        if let priorityView = self.view.subviews.first(where: { $0.tag == 1002 }) as? PriorityView,
           let overlayView = self.view.subviews.first(where: { $0.tag == 888 }) {
            priorityView.removeFromSuperview()
            overlayView.removeFromSuperview()
        }
    }
}

//MARK: - FSCalendarDelegate, FSCalendarDataSource
extension ChangeTaskViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.updateSelectedDate(date: date)
        
        if let calendarView = self.view.subviews.first(where: { $0.tag == 1001 }) as? CalendarPickerView,
           let overlayView = self.view.subviews.first(where: { $0.tag == 999 }) {
            calendarView.hide()
            
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
        
        changeView.textView.becomeFirstResponder()
    }
}
