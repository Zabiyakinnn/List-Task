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
    
    private var taskView = TaskView()
    private var taskDataProvider: TaskDataProvider?
    
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
    
    private func setupButton() {
        taskView.closeVCButton.addTarget(self, action: #selector(closeVCButtonTapped), for: .touchUpInside)
        taskView.newTaskButton.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        taskView.settingsListButton.addTarget(self, action: #selector(settingListButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeVCButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func newTaskButtonTapped() {
        if let nameGroup = nameGroup {
            let newTaskVC = NewTaskViewController(nameGroup: nameGroup)
            newTaskVC.nameGroup = nameGroup
            newTaskVC.newTask = { [weak self] in
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
    
    private func setupContentView() {
        taskView.updateHeader(
            name: nameGroup?.name ?? "Название задачи",
            taskCount: taskDataProvider?.numberOfTask() ?? 0
        )
        
        if let iconData = nameGroup?.iconNameGroup,
            let iconImage = UIImage(data: iconData)?.withRenderingMode(.alwaysTemplate) {
                taskView.iconImageView.image = iconImage
                taskView.iconImageView.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        }
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
            
        } else {
            let taskList = taskDataProvider?.task(at: indexPath)
            let cell = taskView.tableView.dequeueReusableCell(withIdentifier: taskCell, for: indexPath) as? TaskCell

            cell?.configure(taskList!)
            return cell ?? UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
