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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "completed", ascending: true), NSSortDescriptor(key: "nameTask", ascending: true)]
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
    func saveTaskCoreData(nameTask: String, date: Date?, notionTask: String, group: NameGroup?, completion: @escaping(Result<Void, Error>) -> Void) {
        let task = TaskList(context: context)
        
        task.nameTask = nameTask
        task.date = date
        task.group = group
        task.notionTask = notionTask
        group?.addToTasks(task)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure((error)))
        }
    }
    
//    удаление задачи из CoreData
    func deleteTaskCoreData(taskList: TaskList, completion: @escaping (Result<Void, Error>) -> Void) {
        context.delete(taskList) // Удаляем объект контекста
        
        do {
            try context.save() // Сохраняем изменения в Core Data
            completion(.success(())) // Уведомляем об успешном завершении
        } catch {
            completion(.failure(error)) 
        }
    }
    
//    изменение статуса задачи выполненно/не выполненно
    func updateTaskStatus(nameTask: String, newStatus: Bool, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameTask == %@", nameTask)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let taskToUpdate = result.first {
                taskToUpdate.completed = newStatus
                try context.save()
                completion(.success(()))
            } else {
                print("Задача с указаныи именем не найденна")
            }
        } catch {
            completion(.failure((error)))
        }
    }
}
