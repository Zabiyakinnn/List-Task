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
//    сохранение группы для задач в Core Data
    func saveNewGroupCoreData(name: String, iconNameGroup: Data?, existingGroup: NameGroup?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        do {
            let group = existingGroup ?? NameGroup(context: context)
            group.name = name
            group.iconNameGroup = iconNameGroup
            
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure((error)))
        }
    }
    
//    удаление группы задач из Core Data
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
}
