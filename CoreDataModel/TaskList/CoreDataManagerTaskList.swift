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
    
    
    /// сохранение зедачи в CoreData
    /// - Parameters:
    ///   - nameTask: имя задачи
    ///   - date: дата
    ///   - notionTask: заметка
    ///   - priority: приоритет
    ///   - group: группа
    ///   - completion: completion
    func saveTaskCoreData(
        nameTask: String,
        date: Date?,
        notionTask: String?,
        priority: Int?,
        group: NameGroup?,
        completion: @escaping(Result<Void, Error>) -> Void) {
        let task = TaskList(context: context)
        
            task.nameTask = nameTask
            task.date = date
            task.group = group
            task.notionTask = notionTask
            task.priority = Int16(priority ?? 0)
            group?.addToTasks(task)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure((error)))
        }
    }
    
    /// удаление задачи из CoreData
    /// - Parameters:
    ///   - taskList: задача
    ///   - completion: compltion
    func deleteTaskCoreData(taskList: TaskList, completion: @escaping (Result<Void, Error>) -> Void) {
        context.delete(taskList) // Удаляем объект контекста
        
        do {
            try context.save() // Сохраняем изменения в Core Data
            completion(.success(())) // Уведомляем об успешном завершении
        } catch {
            completion(.failure(error)) 
        }
    }
        
    /// изменение статуса задачи выполненно/не выполненно
    /// - Parameters:
    ///   - nameTask: задача
    ///   - newStatus: новый статус задачи
    ///   - completion: completion
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
        
    /// изменение коментария для задачи
    /// - Parameters:
    ///   - nameTask: задача
    ///   - comment: комментарий
    ///   - indexPath: indexPath
    ///   - completion: completion
    func saveComment(nameTask: String, comment: String?, for indexPath: IndexPath, completion: @escaping(Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameTask == %@", nameTask)
        do {
            let result = try context.fetch(fetchRequest)
            if let commentTaskToUpdate = result.first {
                commentTaskToUpdate.notionTask = comment
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
        
    /// изменение приоритета для задачи
    /// - Parameters:
    ///   - nameTask: задача
    ///   - priority: приоритет задачи
    ///   - indexPath: indexPath
    ///   - completion: completion
    func savePriotyTask(nameTask: String, priority: Int16, for indexPath: IndexPath, completion: @escaping(Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameTask == %@", nameTask)

        do {
            let result = try context.fetch(fetchRequest)
            if let priorityTaskUpdate = result.first {
                priorityTaskUpdate.priority = priority
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
        
    /// изменение даты для задачи
    /// - Parameters:
    ///   - nameTask: имя задачи
    ///   - newDate: новая дата задачи
    ///   - indexPath: indexPath
    ///   - completion: completion
    func saveNewDateTask(nameTask: String, newDate: Date?, for indexPath: IndexPath, completion: @escaping(Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameTask == %@", nameTask)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let newDateTask = result.first {
                newDateTask.date = newDate
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
