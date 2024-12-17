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

final class NewTaskViewController: UIViewController {
    
    private var viewModel: NewTaskViewModel // Model
    private var newTaskView = NewTaskView() //ContentView
    let newCommentTaskVC = NewCommentTaskViewController()
    
    //    MARK: Init
    init(viewModel: NewTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        setupBindings()
        setupButton()
        newTaskView.textView.delegate = self
        
    }
    //    MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newTaskView.textView.becomeFirstResponder() // открытие клавитуры для textView
    }
    
    //    настройка привязок с ViewModel
    private func setupBindings() {
        viewModel.onDateUpdated = { [weak self] formattedDate in
            guard let self = self else { return }
            newTaskView.buttonDate.setTitle(formattedDate, for: .normal)
            newTaskView.buttonDate.setImage(nil, for: .normal)
            newTaskView.buttonDate.tintColor = UIColor(named: "SelectedDateCalendarColor")
        }
        
        viewModel.onTaskSaved = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        viewModel.onError = { [weak self] error in
            guard let self = self else { return }
            NotificationUtils.showWarning(on: self, text: error)
        }
        
        if let nameGroup = viewModel.nameGroup.name {
            newTaskView.updateNameGroup(name: nameGroup)
        }
    }
    
    private func setupButton() {
        newTaskView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        newTaskView.buttonDate.addTarget(self, action: #selector(buttonDateTapped), for: .touchUpInside)
        newTaskView.notionTaskButton.addTarget(self, action: #selector(notionTaskButtonTapped), for: .touchUpInside)
    }
    
    //    MARK: ButtonTapped
    //    сохранение задачи
    @objc func saveButtonTapped() {
        viewModel.saveTask(taskText: newTaskView.textView.text)
    }
    
    //выбор даты
    @objc func buttonDateTapped() {
        newTaskView.textView.endEditing(true)
        
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
            
            let calendarView = CalendarPickerView()
            calendarView.tag = 1001
            calendarView.calendar.delegate = self
            calendarView.calendar.dataSource = self
            calendarView.show(in: self.view)
            
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
        newTaskView.textView.becomeFirstResponder()
    }
    
    //    переход на newCommentTaskViewController
    @objc func notionTaskButtonTapped() {
        self.present(newCommentTaskVC, animated: true)
        
        newCommentTaskVC.onColorIconComment = { [weak self] hasText in
            guard let self = self else { return }
            viewModel.commentTask = newCommentTaskVC.newCommentTaskView.textView.text // текст заметки из newCommentTaskVC
            newTaskView.notionTaskButton.tintColor = hasText ? UIColor.systemYellow : UIColor(named: "ButtonIconeImage")
        }
    }
}

//MARK: - UITextViewDelegate
//скрыть календарь при открытой клавитуре в textView
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
        
        newTaskView.textView.becomeFirstResponder()
    }
}
