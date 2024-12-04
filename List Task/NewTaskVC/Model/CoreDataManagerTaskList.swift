//
//  CoreDataManagerTaskList.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 28.11.2024.
//

import UIKit
import CoreData

final class CoreDataManagerTaskList {
    
//    MARK: - Properties
    static let shared = CoreDataManagerTaskList()

    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }
    
//    MARK: - CoreData Methods
    
//    создание FetchResultController
    func createFetchResultController(group: NameGroup?) -> NSFetchedResultsController<TaskList> {
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nameTask", ascending: true)]
        if let group = group {
            fetchRequest.predicate = NSPredicate(format: "group == %@", group)
        }
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
            
        return fetchResultController
    }
    
//    сохранение зедачи в CoreData
    func saveTaskCoreData(nameTask: String, date: Date?, group: NameGroup?, completion: @escaping(Result<Void, Error>) -> Void) {
        let task = TaskList(context: context)
        task.nameTask = nameTask
        task.date = date
        task.group = group
        group?.addToTasks(task)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure((error)))
        }
    }
}
