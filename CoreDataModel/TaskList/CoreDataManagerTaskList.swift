//
//  CoreDataManagerTaskList.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 28.11.2024.
//

import UIKit
import CoreData

final class CoreDataManagerTaskList {
    
    public static let shared = CoreDataManagerTaskList()
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }
    
    private lazy var fetchResultСontroller: NSFetchedResultsController<TaskList> = {
        let fetchRequest = TaskList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nameTask", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
//        fetchRequest.predicate = NSPredicate(format: "group == %@",  ?? "")
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return fetchResultController
    }()
    
//    MARK: - Method
//    создание задачи
    func saveNewTaskCoreData(nameTask: String, existingGroup: NameGroup?, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchResultСontroller.fetchRequest.predicate = NSPredicate(format: "group == %@", existingGroup ?? "")
        guard let group = existingGroup else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не выбрана группа для задачи"])))
            return
        }
        
        let task = TaskList(context: context)
        task.nameTask = nameTask
        task.group = group
        group.addToTasks(task)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure((error)))
        }
    }
}
