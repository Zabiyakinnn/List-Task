//
//  NewTaskProvider.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 30.11.2024.
//

import UIKit
import CoreData

final class NewTaskProvider {
    
//    сохранение новой задачи
    func createNewTask(name: String, date: Date?, notionTask: String?, group: NameGroup, priority: Int?,  statusTask: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.saveTaskCoreData(
            nameTask: name,
            date: date,
            notionTask: notionTask,
            priority: priority,
            group: group,
            completion: completion)
    }
}
