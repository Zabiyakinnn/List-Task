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
    
//    MARK: - Core Data
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private lazy var fetchResultСontroller: NSFetchedResultsController<TaskList> = {
        let fetchRequest = TaskList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nameTask", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "group == %@", nameGroup ?? "")
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: appDelegate.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchResultController.delegate = self
        return fetchResultController
    }()

    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        try? fetchResultСontroller.performFetch()
        setupLoyout()
        view.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    MARK: - ContentView
//    заголовок
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.text = nameGroup?.name
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    изображение
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        if let iconData = nameGroup?.iconNameGroup,
           let iconImage = UIImage(data: iconData)?.withRenderingMode(.alwaysTemplate) {
            imageView.image = iconImage
            imageView.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
//    кол-во задач
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "Кол-во задач: \(fetchResultСontroller.sections?.first?.numberOfObjects ?? 0)"
        label.textColor = .darkGray
        return label
    }()
    
//     table
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        tableView.separatorColor = .gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        return tableView
    }()
    
//    MARK: - UIButton
//    кнопка настройки списка
    private lazy var settingsListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(settingsListButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func settingsListButtonTapped() {
        print("Tapped settingsListButtonTapped")
    }
    
    //    кнопка закрытия ViewController
    private lazy var closeVCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(closeVCButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func closeVCButtonTapped() {
        dismiss(animated: true)
    }
    
    //    новая задача
    private lazy var newTaskButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let iconeImage = UIImage(systemName: "plus.circle")?.withTintColor(UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00), renderingMode: .alwaysOriginal)
        config.image = iconeImage
        config.imagePlacement = .top
        config.imagePadding = 6
        
        var title = AttributedString("Добавить новую задачу")
        title.foregroundColor = .black
        config.attributedTitle = title
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.tintColor = .black
        button.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    @objc func newTaskButtonTapped() {
        print("tapped newTaskButton")
        let newTaskVC = NewTaskViewController()
        newTaskVC.nameGroup = nameGroup
        present(newTaskVC, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = fetchResultСontroller.sections?.first?.numberOfObjects ?? 0
        return itemCount == 0 ? 1: itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCount = fetchResultСontroller.sections?.first?.numberOfObjects ?? 0

        if itemCount == 0 {
            
        } else {
            let taskList = fetchResultСontroller.object(at: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: taskCell, for: indexPath) as? TaskCell

            cell?.configure(taskList)
            return cell ?? UITableViewCell()
        }
        return UITableViewCell()
    }
}

//MARK: - Method
extension TaskViewController {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
                
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func prepereView() {
        view.addSubview(labelHeadline)
        view.addSubview(iconImageView)
        view.addSubview(settingsListButton)
        view.addSubview(closeVCButton)
        view.addSubview(taskCountLabel)
        view.addSubview(newTaskButton)
        view.addSubview(tableView)
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(72)
            make.left.equalTo(view.snp.left).inset(70)
            make.height.equalTo(34)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(76)
            make.left.equalTo(view.snp.left).inset(30)
            make.height.width.equalTo(30)
        }
        settingsListButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(23)
            make.left.equalTo(view.snp.left).inset(30)
            make.height.width.equalTo(30)
        }
        closeVCButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(23)
            make.right.equalTo(view.snp.right).inset(30)
            make.height.width.equalTo(30)
        }
        taskCountLabel.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(43)
            make.left.equalTo(view.snp.left).inset(70)
        }
        newTaskButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(0)
            make.bottom.equalTo(view.snp.bottom).inset(0)
            make.height.equalTo(90)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(0)
            make.top.equalTo(taskCountLabel.snp.top).inset(32)
            make.bottom.equalTo(newTaskButton.snp.bottom).inset(90)
        }
    }
}

