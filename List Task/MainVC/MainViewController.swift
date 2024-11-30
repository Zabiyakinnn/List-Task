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
    private let coreDataManager = CoreDataManagerNameGroup.shared
    private let groupCellCollection = "groupCellCollection"

//    MARK: - LoadView
    override func loadView() {
        self.view = mainView
    }
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        
        try? coreDataManager.fetchResultСontroller.performFetch()
        
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
        do {
            try coreDataManager.fetchResultСontroller.performFetch()
            mainView.collectionView.reloadData()
        } catch {
            print("Ошибка обновления данных коллекции \(error.localizedDescription)")
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = coreDataManager.fetchResultСontroller.sections?.first?.numberOfObjects ?? 0
        return itemCount == 0 ? 1: itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCount = coreDataManager.fetchResultСontroller.sections?.first?.numberOfObjects ?? 0
        
        if itemCount == 0 {
            let placeholderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCell
            placeholderCell.configure(with: "Создайте группу для своих задач")
            return placeholderCell
        } else {
            let nameGroup = coreDataManager.fetchResultСontroller.object(at: indexPath)
            
            let fetchController = CoreDataManagerTaskList.shared.createFetchResultController(group: nameGroup)
            try? fetchController.performFetch()
            let taskCount = fetchController.fetchedObjects?.count ?? 0
            
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
                    coreDataManager.deleteGroupTask(existingGroup: nameGroup) { result in
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
        let newTaskVC = TaskViewController()
        let nameGroup = coreDataManager.fetchResultСontroller.object(at: indexPath)
        newTaskVC.nameGroup = nameGroup
        navigationController?.present(newTaskVC, animated: true)
    }
}
