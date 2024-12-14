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

    private let mainView = MainView()
    private let mainViewProvider = MainViewProvider(coreDataManager: CoreDataManagerNameGroup.shared)
    private let groupCellCollection = "groupCellCollection"

//    MARK: - LoadView
    override func loadView() {
        self.view = mainView
    }
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
            
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupButton() {
        mainView.newGroupTaskButton.addTarget(self, action: #selector(newGroupButtonTapped), for: .touchUpInside)
        mainView.settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
    }
    
    @objc private func newGroupButtonTapped() {
        let newGroupVC = NewGroupTaskViewController()
        newGroupVC.newGroupName = { [weak self] in
            self?.reloadCollectionView()
        }
        navigationController?.present(newGroupVC, animated: true)
    }
    
    @objc private func settingButtonTapped() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
//    обновление коллекции
    private func reloadCollectionView() {
        mainView.collectionView.reloadData()
        mainViewProvider.perfomFetch()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = mainViewProvider.numberOfTaskGroup()
        return itemCount == 0 ? 1: itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCount = mainViewProvider.numberOfTaskGroup()
        
        if itemCount == 0 {
            let placeholderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCell
            placeholderCell.configure(with: "Создайте группу для своих задач")
            return placeholderCell
        } else {
            
            guard let nameGroup = mainViewProvider.groupAt(indexPath: indexPath) else {
                print("Name Group nil")
                return UICollectionViewCell()
            }
            
            let taskCount = mainViewProvider.numberOfTaskInGroup(at: indexPath)
            
            let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: groupCellCollection, for: indexPath) as! GroupCellCollection
            
            cell.configure(nameGroup, taskCount)
            
            cell.onDelete = { [weak self] in
                let alertController = UIAlertController(
                    title: nil,
                    message: "Удалить грппу \(nameGroup.name ?? "") со всеми задачами?",
                    preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
                alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
                    guard let self = self else { return }
                    mainViewProvider.deleteGroup(at: indexPath) { result in
                        switch result {
                        case .success():
                            self.reloadCollectionView()
                        case .failure(let error):
                            print("Ошибка удаления задачи из Core Data: \(error.localizedDescription)")
                        }
                    }
                }))
                self?.navigationController?.present(alertController, animated: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let nameGroup = mainViewProvider.groupAt(indexPath: indexPath) {
            let taskDataProvide = TaskDataProvider(group: nameGroup)
            let taskViewModel = TaskViewModel(taskDataProvider: taskDataProvide, nameGroup: nameGroup)
            let taskVC = TaskViewController(viewModel: taskViewModel)
            if let nameGroup = mainViewProvider.groupAt(indexPath: indexPath) {
                taskViewModel.nameGroup = nameGroup
                taskVC.newTask = { [weak self] in
                    guard let self = self else { return }
                    self.mainViewProvider.perfomFetch()
                    self.mainView.collectionView.reloadData()
                }
                taskVC.deleteTask = { [weak self] in
                    guard let self = self else { return }
                    self.mainViewProvider.perfomFetch()
                    self.mainView.collectionView.reloadData()
                }
            }
            navigationController?.present(taskVC, animated: true)
        }
    }
}
