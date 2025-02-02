//
//  ChangeTaskProvider.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 30.01.2025.
//

import Foundation

final class ChangeTaskProvider {
    
//    сохранение изменненой задачи в CoreData
    func changeTask(
        task: TaskList,
        newNameTask: String,
        newDate: Date?,
        newNotionTask: String?,
        newPriority: Int?,
        newGroup: NameGroup,
        newStatusTask: Bool?,
        completion: @escaping(Result<Void, Error>) -> Void) {
            CoreDataManagerTaskList.shared.changeTask(
                task: task,
                newName: newNameTask,
                newDate: newDate,
                newNotionTask: newNotionTask,
                newPriority: newPriority,
                group: newGroup,
                newStatusTask: newStatusTask,
                completion: completion)
    }
}
