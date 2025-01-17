//
//  SettingDataProvider.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 10.01.2025.
//

import UIKit
import CoreData

final class SettingDataProvider {
    
    private let fetchResultController: NSFetchedResultsController<TaskList>

    init(group: NameGroup) {
        fetchResultController = CoreDataManagerTaskList.shared.createFetchResultController(group: group)
        try? fetchResultController.performFetch()
    }
    
    
    /// сохранение изменной задачи
    /// - Parameters:
    ///   - newName: новое имя
    ///   - newIcon: новая иконка
    ///   - completion: completion
    func changeGroupTask(exestiongGroup: NameGroup ,newName: String, newIcon: Data?, colorIcon: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManagerNameGroup.shared.changeGroupTask(existingGroup: exestiongGroup,
                                                        newName: newName,
                                                        newIcon: newIcon,
                                                        colorIcon: colorIcon,
                                                        completion: completion)
    }
}
