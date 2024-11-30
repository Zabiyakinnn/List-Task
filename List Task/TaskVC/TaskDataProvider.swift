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
    
    func numberOfTask() -> Int {
        return fetchResultController.sections?.first?.numberOfObjects ?? 0
    }
    
    func task(at indexPath: IndexPath) -> TaskList? {
        return fetchResultController.object(at: indexPath)
    }
    
    func perfomFetch() {
        try? fetchResultController.performFetch()
    }
}
