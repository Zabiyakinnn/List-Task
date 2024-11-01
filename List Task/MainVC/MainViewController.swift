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
    
//    MARK: - CoreData
    private lazy var fetchResultСontroller: NSFetchedResultsController<NameGroup> = {
        let fetchRequest = NameGroup.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ListTask")
        container.loadPersistentStores { description, error in
            if let error = error as? NSError {
                print("Error loading persistent store: \(error.localizedDescription)")
                print("Details: \(error), \(error.userInfo)")
            } else {
                print("DB url - \(description.url?.absoluteString ?? "")")
            }
        }
        return container
    }()

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
        navigationController?.present(newGroupVC, animated: true)
    }
}

//MARK: - Extension MainVC
private extension MainViewController {
    private func setupLoyout() {
        prepareView()
        setupConstraint()
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultСontroller.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Проверяем, есть ли данные в разделе
        guard let sections = fetchResultСontroller.sections, sections[indexPath.section].numberOfObjects > indexPath.item else {
            // Возвращаем пустую ячейку или другую ячейку для отображения, если данных нет
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath)
            return emptyCell
        }
        
        let nameGroup = fetchResultСontroller.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCellCollection, for: indexPath) as! TaskCellCollection
        cell.configure(nameGroup)
        return cell
    }
}

