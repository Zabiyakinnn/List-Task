//
//  TaskDataProvider.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 29.11.2024.
//

import UIKit
import CoreData

final class TaskDataProvider {
    
    private let fetchResultController: NSFetchedResultsController<TaskList>
    
    init(group: NameGroup) {
        fetchResultController = CoreDataManagerTaskList.shared.createFetchResultController(group: group)
        try? fetchResultController.performFetch()
    }
    
    
    //    кол-во задач
    func numberOfTask() -> Int {
        return fetchResultController.sections?.first?.numberOfObjects ?? 0
    }
    
    //    получение списка задач по indexPath
    func task(at indexPath: IndexPath) -> TaskList? {
        return fetchResultController.object(at: indexPath)
    }
    
    //    обновление данных
    func perfomFetch() {
        try? fetchResultController.performFetch()
    }
    
    //    удаление задачи
    func deleteTask(taskList: TaskList, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.deleteTaskCoreData(
            taskList: taskList,
            completion: completion)
        
    }
    
    //    изменение статуса задачи выполненно/не выполненно
    func updateTaskStatus(idTask: UUID, newStatus: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.updateTaskStatus(
            idTask: idTask,
            newStatus: newStatus,
            completion: completion)
    }
        
    /// сохранение изменного коментария задчи
    /// - Parameters:
    ///   - nameTask: имя задачи
    ///   - comment: коменнтарий для задачи
    ///   - indexPath: indexPath
    ///   - completion: completion
    func saveComment(idTask: UUID, comment: String?, for indexPath: IndexPath, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.saveComment(
            idTask: idTask,
            newComment: comment,
            for: indexPath,
            completion: completion)
    }
        
    /// сохранение изменного приоритета для задачи
    /// - Parameters:
    ///   - nameTask: имя задачи
    ///   - priority: приоритет
    ///   - indexPath: indexPath
    ///   - completion: completion
    func savePriorityTask(idTask: UUID, priority: Int16, for indexPath: IndexPath, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.savePriotyTask(
            idTask: idTask,
            priority: priority,
            for: indexPath,
            completion: completion)
    }
    
    
    /// сохранение изменной даты для задачи
    /// - Parameters:
    ///   - nameTask: имя задачи
    ///   - newDate: новая дата
    ///   - indexPath: indexPath
    ///   - compltion: completion
    func saveNewDateTask(idTask: UUID, newDate: Date?, for indexPath: IndexPath, compltion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.saveNewDateTask(
            idTask: idTask,
            newDate: newDate,
            for: indexPath,
            completion: compltion)
    }
}
