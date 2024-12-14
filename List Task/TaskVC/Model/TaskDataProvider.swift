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
    func updateTaskStatus(nameTask: String, newStatus: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.updateTaskStatus(
            nameTask: nameTask,
            newStatus: newStatus,
            completion: completion)
    }
    
//    сохранения изменненого комментария задачи
    func saveComment(nameTask: String, comment: String?, for indexPath: IndexPath, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.saveComment(
            nameTask: nameTask,
            comment: comment,
            for: indexPath,
            completion: completion)
    }
}
