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
    func createNewTask(name: String, date: Date?, group: NameGroup, statusTask: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerTaskList.shared.saveTaskCoreData(
            nameTask: name,
            date: date,
            group: group,
            completion: completion)
    }
}