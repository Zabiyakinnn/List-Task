//
//  TaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.11.2024.
//

import UIKit
import SnapKit
import CoreData

final class TaskViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var nameGroup: NameGroup?
    let taskCell = "taskCell"
    
    var newTask: (() -> Void)? // передача в mainVC
    var deleteTask: (() -> Void)? // передача в mainVC о том что задача удаленна для обновления кол-ва задач в подгруппе
    
    private var taskView = TaskView()
    private var taskDataProvider: TaskDataProvider?
    private var newTaskProvider = NewTaskProvider()
    
    //    MARK: LoadView
    override func loadView() {
        self.view = taskView
    }
    
    //    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let group = nameGroup {
            taskDataProvider = TaskDataProvider(group: group)
        }
        taskDataProvider?.perfomFetch()
        
        setupContentView()
        setupButton()
        
        taskView.tableView.delegate = self
        taskView.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupContentView() {
        taskView.updateHeader(
            name: nameGroup?.name ?? "Название задачи",
            taskCount: taskDataProvider?.numberOfTask() ?? 0
        )
        
        if let iconData = nameGroup?.iconNameGroup,
           let iconImage = UIImage(data: iconData)?.withRenderingMode(.alwaysTemplate) {
            taskView.iconImageView.image = iconImage
            taskView.iconImageView.tintColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        }
        
        let isEmpty = taskDataProvider?.numberOfTask() == 0
        taskView.tableView.isHidden = isEmpty
        taskView.emptyView.isHidden = !isEmpty
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
        if let nameGroup = nameGroup {
            let viewModel = NewTaskViewModel(taskProvider: newTaskProvider, nameGroup: nameGroup)
            let newTaskVC = NewTaskViewController(viewModel: viewModel)
            viewModel.nameGroup = nameGroup
            viewModel.newTask = { [weak self] in
                guard let self = self else { return }
                self.newTask?()
                taskDataProvider?.perfomFetch()
                setupContentView()
                taskView.tableView.reloadData()
            }
            present(newTaskVC, animated: true)
        }
    }
    
    @objc func settingListButtonTapped() {
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = taskDataProvider?.numberOfTask() ?? 0
        return itemCount == 0 ? 1: itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCount = taskDataProvider?.numberOfTask() ?? 0
        
        if itemCount == 0 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            
            let emptyView = taskView.emptyView
            cell.contentView.addSubview(emptyView)
            
            emptyView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            if let taskList = taskDataProvider?.task(at: indexPath) {
                let cell = taskView.tableView.dequeueReusableCell(withIdentifier: taskCell, for: indexPath) as? TaskCell
                
                cell?.configure(taskList)
                cell?.onConditionButtonStatus = { [weak self] newStatus in
                    guard let self = self else { return }
                    taskDataProvider?.updateTaskStatus(
                        nameTask: taskList.nameTask ?? "",
                        newStatus: newStatus,
                        completion: { result in
                            switch result {
                            case .success():
                                self.taskDataProvider?.perfomFetch()
                                self.taskView.tableView.reloadRows(at: [indexPath], with: .none)
                                self.taskView.tableView.reloadData()
                            case .failure(let error):
                                print("Ошибка изменения статуса задачи \(error.localizedDescription)")
                            }
                        })
                }
                return cell ?? UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //    свайп ячейки вправо
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            
            if let taskToDelete = taskDataProvider?.task(at: indexPath) {
                taskDataProvider?.deleteTask(taskList: taskToDelete) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success():
                        self.taskDataProvider?.perfomFetch()
                        self.deleteTask?()
                        if taskDataProvider?.numberOfTask() == 0 {
                            DispatchQueue.main.async {
                                self.taskView.tableView.reloadData()
                                self.setupContentView()
                            }
                        } else {
                            DispatchQueue.main.async {
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                self.taskView.tableView.reloadData()
                                self.setupContentView()
                            }
                        }
                    case .failure(let error):
                        print("Ошибка удаления задачи из CoreData: - \(error.localizedDescription)")
                    }
                }
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false //отключение уделния ячейки свайпом
        return configuration
    }
    
    //    свайп ячейки влево
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //        календарь
        let calendarAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            completion(true)
        }
        calendarAction.image = UIImage(systemName: "calendar")
        calendarAction.backgroundColor = UIColor(named: "ColorSwipeButtonCallendar")
        
        //        комментарий
        let commentTaskAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            completion(true)
        }
        commentTaskAction.image = UIImage(systemName: "list.clipboard")
        commentTaskAction.backgroundColor = UIColor(named: "ColorSwipeButtonComment")
        
        let configuration = UISwipeActionsConfiguration(actions: [calendarAction, commentTaskAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
