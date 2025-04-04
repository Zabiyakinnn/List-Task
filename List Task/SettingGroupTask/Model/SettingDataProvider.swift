//
//  SettingDataProvider.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 10.01.2025.
//

import UIKit
import CoreData

final class SettingDataProvider {
    
    private let fetchResultController: NSFetchedResultsController<NameGroup>  
    private let coreDataManager: CoreDataManagerNameGroup

    init(coreDataManager: CoreDataManagerNameGroup) {
        self.coreDataManager = coreDataManager
        self.fetchResultController = coreDataManager.fetchResultСontroller
        try? fetchResultController.performFetch()
    }
    
//    получаем группу по индексу
    private func group(indexPath: IndexPath) -> NameGroup? {
        return fetchResultController.object(at: indexPath)
    }
    
    /// сохранение изменной задачи
    /// - Parameters:
    ///   - newName: новое имя
    ///   - newIcon: новая иконка
    ///   - completion: completion
    func changeGroupTask(exestiongGroup: NameGroup ,newName: String, newIcon: Data?, colorIcon: Data?, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerNameGroup.shared.changeGroupTask(
            existingGroup: exestiongGroup,
            newName: newName,
            newIcon: newIcon,
            colorIcon: colorIcon,
            completion: completion)
    }
    
//    /// удаление группы задач
//    /// - Parameters:
//    ///   - indexPath: indexPath задачи
//    ///   - completion: completion
//    func deleteGroup(at indexPath: IndexPath, completion: @escaping(Result<Void, Error>) -> Void) {
//        guard let group = group(indexPath: indexPath) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Группа не найдена"])))
//            return
//        }
//        coreDataManager.deleteGroupTask(existingGroup: group, completion: completion)
//    }
    
    func deleteGroup(by uuid: UUID, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let group = coreDataManager.fetchGroup(by: uuid) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Группа не найдена"])))
            return
        }
        coreDataManager.deleteGroupTask(existingGroup: group, completion: completion)
    }
}
