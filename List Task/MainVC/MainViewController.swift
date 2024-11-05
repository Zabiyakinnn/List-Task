//
//  ViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 31.10.2024.
//

import UIKit
import SnapKit
import CoreData

final class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {

    var taskCellCollection = "taskCellCollection" 
    var nameGroup: NameGroup?
    
//    MARK: - CoreData
    private lazy var fetchResultСontroller: NSFetchedResultsController<NameGroup> = {
        // Создаём запрос для выборки данных
        let fetchRequest = NameGroup.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Инициализируем fetchResultController с fetchRequest и context из контейнера
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: appDelegate.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        // Устанавливаем делегат
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        try? fetchResultСontroller.performFetch()
        setupLoyout()
        view.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    collection
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10 // расстояние между элементами
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 80) // размер элемента
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(TaskCellCollection.self, forCellWithReuseIdentifier: "taskCellCollection")
        collectionView.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
//    заголовок
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.text = "List Task"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

//    сегодняшняя дата
    private lazy var labelData: UILabel = {
        let label = UILabel()
        let currentData = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        let formatterData = dateFormatter.string(for: currentData)
        label.text = formatterData
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
//    MARK: - Button
//    кнопка настройки
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    кнопка добавить группу задач
    private lazy var newGroupTask: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(newGroupButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func settingsButtonTapped() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func newGroupButtonTapped() {
        let newGroupVC = NewGroupTaskViewController()
        newGroupVC.newGroupName = { [weak self] in
            guard let self = self else { return }
            do {
                try self.fetchResultСontroller.performFetch()
                self.collectionView.reloadData()
            } catch {
                print("Ошибка удаления данных \(error)")
            }
        }
        navigationController?.present(newGroupVC, animated: true)
    }
    
//    удаление группы для задач
    private func deleteTask(nameGroup: NameGroup) {
        let alertController = UIAlertController(title: nil, message: "Удалить группу задач?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NameGroup.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", nameGroup.name ?? "")
            
            do {
                let result = try context.fetch(fetchRequest)
                if let groupToDelete = result.first {
                    context.delete(groupToDelete)
                    try context.save()
                    try fetchResultСontroller.performFetch()
                    collectionView.reloadData()
                }
            } catch {
                print("Ошибка удаления группы задач из Core Data \(error)")
            }
        }))
        present(alertController, animated: true)
    }
}

//MARK: - Extension MainVC
private extension MainViewController {
    private func setupLoyout() {
        prepareView()
        setupConstraint()
        collectionView.register(PlaceholderCell.self, forCellWithReuseIdentifier: "PlaceholderCell")
    }
    
    func prepareView() {
        view.addSubview(collectionView)
        view.addSubview(labelData)
        view.addSubview(labelHeadline)
        view.addSubview(settingsButton)
        view.addSubview(newGroupTask)
    }
    
    func setupConstraint() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelData.snp.top).offset(40)
            make.left.equalTo(view.snp.left).offset(12)
            make.right.equalTo(view.snp.right).offset(-12)
            make.bottom.equalToSuperview()
        }
        labelHeadline.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(66)
            make.left.equalTo(view.snp.left).inset(30)
            make.height.equalTo(34)
            make.width.equalTo(150)
        }
        labelData.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(50)
            make.left.equalTo(view.snp.left).inset(32)
            make.height.equalTo(20)
        }
        settingsButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).inset(16)
            make.top.equalTo(view.snp.top).inset(60)
            make.height.width.equalTo(40)
        }
        newGroupTask.snp.makeConstraints { make in
            make.right.equalTo(settingsButton.snp.right).inset(40)
            make.top.equalTo(view.snp.top).inset(60)
            make.height.width.equalTo(40)
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = fetchResultСontroller.sections?.first?.numberOfObjects ?? 0
        return itemCount == 0 ? 1: itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCount = fetchResultСontroller.sections?.first?.numberOfObjects ?? 0
        
        if itemCount == 0 {
            let placeholderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCell
            placeholderCell.configure(with: "Создайте группу для своих задач")
            return placeholderCell
        } else {
            let nameGroup = fetchResultСontroller.object(at: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCellCollection, for: indexPath) as! TaskCellCollection
            
            cell.configure(nameGroup)
            
            cell.onDelete = { [weak self] in
                guard let self = self else { return }
                deleteTask(nameGroup: nameGroup)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newTaskVC = NewTaskViewController()
        let nameGroup = fetchResultСontroller.object(at: indexPath)
        newTaskVC.nameGroup = nameGroup
        navigationController?.present(newTaskVC, animated: true)
    }
}




