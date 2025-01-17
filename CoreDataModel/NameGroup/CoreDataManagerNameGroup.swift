//
//  CoreDataManagerNameGroup.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 22.11.2024.
//

import UIKit
import CoreData

final class CoreDataManagerNameGroup {
    
    public static let shared = CoreDataManagerNameGroup()
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }
    
    //    MARK: - CoreData
    lazy var fetchResultСontroller: NSFetchedResultsController<NameGroup> = {
        // Создаём запрос для выборки данных
        let fetchRequest = NameGroup.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Инициализируем fetchResultController с fetchRequest и context из контейнера
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchResultController
    }()
    
//    MARK: Method
    
    /// сохранение группы для задач в Core Data
    /// - Parameters:
    ///   - name: имя
    ///   - iconNameGroup: иконка для задачи
    ///   - existingGroup: существующая группа
    ///   - completion: completion
    func saveNewGroupCoreData(name: String, iconNameGroup: Data?, existingGroup: NameGroup?, iconColor: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let group = existingGroup ?? NameGroup(context: context)
            group.name = name
            group.iconNameGroup = iconNameGroup
            group.colorIcon = iconColor
            
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure((error)))
        }
    }
        
    /// удаление группы задач из Core Data
    /// - Parameters:
    ///   - existingGroup: существующая группа
    ///   - completion: completion
    func deleteGroupTask(existingGroup: NameGroup?, completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<NameGroup> = NameGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", existingGroup?.name ?? "")
        do {
            let result = try context.fetch(fetchRequest)
            if let groupToDelete = result.first {
                context.delete(groupToDelete)
                try context.save()
                completion(.success(()))
            } else {
                print("Задача не найденна в CoreData")
            }
        } catch {
            completion(.failure((error)))
        }
    }
    
    
    /// Изменение группы задач
    /// - Parameters:
    ///   - newName: новое имя группы
    ///   - newIcon: новая иконка группы
    ///   - completion: completion
    func changeGroupTask(existingGroup: NameGroup, newName: String, newIcon: Data?, colorIcon: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<NameGroup> = NameGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", existingGroup.name ?? "")
        
        do {
            let result = try context.fetch(fetchRequest)
            if let changeGroup = result.first {
                changeGroup.name = newName
                changeGroup.iconNameGroup = newIcon
                changeGroup.colorIcon = colorIcon
                try context.save()
                completion(.success(()))
            } else {
                let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Задача не найденна"])
                completion(.failure((error)))
            }
        } catch {
            completion(.failure((error)))
        }
    }
}
