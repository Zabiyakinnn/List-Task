//
//  MainViewProvider.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 30.11.2024.
//

import UIKit
import CoreData

final class MainViewProvider {
    
    private let fetchResultController: NSFetchedResultsController<NameGroup>
    private let coreDataManager: CoreDataManagerNameGroup
    
    init(coreDataManager: CoreDataManagerNameGroup) {
        self.coreDataManager = coreDataManager
        self.fetchResultController = coreDataManager.fetchResultСontroller
        try? fetchResultController.performFetch()
    }
    
//    кол-во групп задач
    func numberOfTaskGroup() -> Int {
        return fetchResultController.sections?.first?.numberOfObjects ?? 0
    }
    
//    получаем объект группы задач по заданному indexPath
    func groupAt(indexPath: IndexPath) -> NameGroup? {
        return fetchResultController.object(at: indexPath)
    }
    
//    создание новой задачи в CoreData
    func createNewGroup(name: String, iconNameGroup: Data?, iconColor: Data?, completion: @escaping(Result<Void, Error>) -> Void) {
        coreDataManager.saveNewGroupCoreData(name: name, iconNameGroup: iconNameGroup, existingGroup: nil, iconColor: nil, completion: completion)
    }
    
//    удалние задачи из CoreData
    func deleteGroup(at indexPath: IndexPath, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let group = groupAt(indexPath: indexPath) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Группа не найдена"])))
            return
        }
        coreDataManager.deleteGroupTask(existingGroup: group, completion: completion)
    }
    
//    получам кол-во задач в конкретной группе по indexPAth
    func numberOfTaskInGroup(at indexPath: IndexPath) -> Int {
        guard let group = groupAt(indexPath: indexPath) else { return 0 }
        let fetchController = CoreDataManagerTaskList.shared.createFetchResultController(group: group)
        try? fetchController.performFetch()
        return fetchController.fetchedObjects?.count ?? 0
    }
    
//    обновление данных
    func perfomFetch() {
        try? fetchResultController.performFetch()
    }
}
