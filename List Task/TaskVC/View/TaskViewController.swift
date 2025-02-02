//
//  TaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.11.2024.
//

import UIKit
import SnapKit
import CoreData
import FSCalendar

final class TaskViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private var viewModel: TaskViewModel
    private var taskView = TaskView()
    let priorityView = PriorityView()
    let taskCell = "taskCell"
    
    var newTask: (() -> Void)? // передача в mainVC уведомления о добавлении новой задачи
    var onGroup: (() -> Void)? // передача  mainVC уведомлния об изменении параметров группы задач
    var deleteTask: (() -> Void)? // передача в mainVC о том что задача удаленна для обновления кол-ва задач в подгруппе
    
    //    MARK: - Init
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: LoadView
    override func loadView() {
        self.view = taskView
    }
    
    //    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupContentView()
        setupButton()
        
        taskView.tableView.delegate = self
        taskView.tableView.dataSource = self
        
        viewModel.reloadTask()
    }
    
    //    MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //    Настройка привязок с ViewModel
    private func setupBinding() {
        viewModel.onTaskUpdated = { [weak self] in
            guard let self = self else { return }
            setupContentView()
            self.taskView.tableView.reloadData()
        }
        
        viewModel.onTaskDelete = { [weak self] in
            self?.deleteTask?()
        }
    }
    
    private func setupContentView() {
        taskView.updateHeader(
            name: viewModel.nameGroup.name ?? "Название задачи",
            taskCount: viewModel.countTask()
        )
        
        if let iconData = viewModel.nameGroup.iconNameGroup,
           let iconImage = UIImage(data: iconData)?.withRenderingMode(.alwaysTemplate) {
            taskView.iconImageView.image = iconImage
            
            let colorIndex = Int(viewModel.nameGroup.colorIcon)
            //            если индекс находится в пределах массива
            if colorIndex >= 0 && colorIndex < ColorPalette.colors.count {
                let selectedColor = ColorPalette.colors[colorIndex]
                applyColorToIcon(selectedColor)
            } else {
                //                индекс не валиден
                applyColorToIcon(UIColor(named: "ButtonIconeImage") ?? .lightGray)
            }
        }
        
        let isEmpty = viewModel.countTask() == 0
        taskView.tableView.isHidden = isEmpty
        taskView.emptyView.isHidden = !isEmpty
    }
    
    //    применение цвета к иконке
    func applyColorToIcon(_ color: UIColor) {
        taskView.iconImageView.tintColor = color
    }
    
    private func setupButton() {
        taskView.closeVCButton.addTarget(self, action: #selector(closeVCButtonTapped), for: .touchUpInside)
        taskView.newTaskButton.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        taskView.settingsListButton.addTarget(self, action: #selector(settingListButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeVCButtonTapped() {
        dismiss(animated: true)
    }
    
    //    MARK: - Button
    //    открыть контроллер с созданием новой задачи
    @objc func newTaskButtonTapped() {
        let newTaskViewModel = viewModel.createNewTaskViewModel()
        let newTaskVC = NewTaskViewController(viewModel: newTaskViewModel)
        newTaskViewModel.newTask = { [weak self] in
            guard let self = self else { return }
            self.newTask?()
            viewModel.reloadTask()
            setupContentView()
            taskView.tableView.reloadData()
        }
        present(newTaskVC, animated: true)
    }
    
//    открыть контроллер с настройками группы задач
    @objc func settingListButtonTapped() {
        let nameGroup = viewModel.nameGroup
        let settingDataProvider = SettingDataProvider(group: nameGroup)
        
        let settingViewModel = SettingViewModel(settingDataProvider: settingDataProvider, nameGroup: nameGroup)
        let settingGroupTaskVC = SettingGroupTaskVC(viewModel: settingViewModel)
        settingGroupTaskVC.onGroupSaved = { [weak self] in
            guard let self = self else { return }
//            setupContentView()
            self.onGroup?()
            viewModel.reloadTask()
        }
        present(settingGroupTaskVC, animated: true)
    }
    
    //    открыть календарь и выбрать дату
    func openCalendarView(at indexPath: IndexPath, taskList: TaskList?) {
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
            
            if let selectedDate = taskList?.date {
                calendarView.calendar.select(selectedDate)
            } else {
                print("пустая дата")
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            })
        }
    }
    
    //        открыть view с приоритетом
    func openPriorityView(at indexPath: IndexPath, taskList: TaskList?) {
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
            priorityView.initialSelectedPriority = Int(taskList?.priority ?? 0) // передача выбранного ранее приоритета
            priorityView.show(in: self.view)
            
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
        }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countTask()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.countTask() == 0 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            
            let emptyView = taskView.emptyView
            cell.contentView.addSubview(emptyView)
            
            emptyView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            if let taskList = viewModel.task(at: indexPath) {
                let cell = taskView.tableView.dequeueReusableCell(withIdentifier: taskCell, for: indexPath) as? TaskCell
                
                cell?.configure(taskList)
                cell?.colorConditionButton(taskList: taskList)
                cell?.onConditionButtonStatus = { [weak self] newStatus in
                    guard let self = self else { return }
                    viewModel.changeStatusButton(at: indexPath, to: newStatus) { result in
                        switch result {
                        case .success():
                            self.taskView.tableView.reloadRows(at: [indexPath], with: .none)
                        case .failure(let error):
                            print("Ошибка изменения статуса задачи \(error.localizedDescription)")
                        }
                    }
                }
                return cell ?? UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = viewModel.task(at: indexPath)
        guard let selectedTask = CoreDataManagerTaskList.shared.fetchTodosFromCoreData()?.first(where: { $0.nameTask ==  selectedTodo?.nameTask}) else {
            print("Не удалось найти задачу в CoreData")
            return
        }
        let changeTaskProvider = ChangeTaskProvider()
        let changeTaskViewModel = ChangeTaskViewModel(nameGroup: viewModel.nameGroup, taskList: selectedTask, changeTaskProvider: changeTaskProvider)
        let changeTaskVC = ChangeTaskViewController(viewModel: changeTaskViewModel)
        changeTaskViewModel.onChangeTask = { [weak self] in
            guard let self = self else { return }
            taskView.tableView.reloadData()
        }
        self.present(changeTaskVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //    свайп ячейки влево
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            
            self.viewModel.deleteTask(at: indexPath) { result in
                switch result {
                case .success():
                    completion(true)
                case .failure(let error):
                    print("Ошибка удаления задачи \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false //отключение уделния ячейки свайпом
        return configuration
    }
    
    //    свайп ячейки вправо
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //        календарь
        let calendarAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            if let taskList = viewModel.task(at: indexPath) {
                openCalendarView(at: indexPath, taskList: taskList)
                
                viewModel.onNewDateTask = { [weak self] newDate in
                    guard let self = self else { return }
                    viewModel.saveNewDate(at: indexPath, newDate: newDate) { result in
                        switch result {
                        case .success():
                            self.taskView.tableView.reloadRows(at: [indexPath], with: .none)
                        case .failure(let error):
                            print("Ошибка сохранения новой даты для задачи \(error.localizedDescription)")
                        }
                    }
                }
            }
            completion(true)
        }
        calendarAction.image = UIImage(systemName: "calendar")
        calendarAction.backgroundColor = UIColor(named: "ColorSwipeButtonCallendar")
        
//        view с выбором приоритета
        let priprityViewAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            if let taskList = viewModel.task(at: indexPath) {
                openPriorityView(at: indexPath, taskList: taskList)
                
                priorityView.onPrioritySelected = { [weak self] index in
                    guard let self = self else { return }
                    viewModel.savePriorityTask(at: indexPath, newPriority: index) { result in
                        switch result {
                        case .success():
                            self.taskView.tableView.reloadRows(at: [indexPath], with: .none)
                        case .failure(let error):
                            print("Ошибка сохранение нового приоритета для задачи \(error.localizedDescription)")
                        }
                        self.closePriorityView()
                    }
                }
            }
            completion(true)
        }
        priprityViewAction.image = UIImage(systemName: "flag")
        priprityViewAction.backgroundColor = UIColor(named: "ColorSwipeButtonPriorityView")
        
        //        комментарий
        let commentTaskAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            if let taskList = viewModel.task(at: indexPath) {
                let newCommentTaskVC = NewCommentTaskViewController()
                newCommentTaskVC.newCommentTaskView.textView.text = taskList.notionTask
                
                newCommentTaskVC.onTextCommentTask = { [weak self] comment in
                    self?.viewModel.saveComment(at: indexPath, newComment: comment, completion: { result in
                        switch result {
                        case .success():
                            self?.taskView.tableView.reloadRows(at: [indexPath], with: .none)
                        case .failure(let error):
                            print("Ошибка сохранения комментария для задачи \(error.localizedDescription)")
                        }
                    })
                }
                self.present(newCommentTaskVC, animated: true)
            }
            completion(true)
        }
        commentTaskAction.image = UIImage(systemName: "list.clipboard")
        commentTaskAction.backgroundColor = UIColor(named: "ColorSwipeButtonComment")
        
        let configuration = UISwipeActionsConfiguration(actions: [calendarAction, commentTaskAction, priprityViewAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

//MARK: - FSCalendarDelegate, FSCalendarDataSource
extension TaskViewController: FSCalendarDelegate, FSCalendarDataSource {
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
    }
}
