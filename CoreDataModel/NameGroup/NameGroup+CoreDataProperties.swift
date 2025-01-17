//
//  NameGroup+CoreDataProperties.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 02.11.2024.
//
//

import Foundation
import CoreData

@objc(NameGroup)
public class NameGroup: NSManagedObject {}

extension NameGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NameGroup> {
        return NSFetchRequest<NameGroup>(entityName: "NameGroup")
    }

    @NSManaged public var name: String?
    @NSManaged public var iconNameGroup: Data?
    @NSManaged public var colorIcon: Int64
    @NSManaged public var tasks: NSSet?

}

extension NameGroup {
    
    func addTaskToGroup(group: NameGroup, nameGroup: String, context: NSManagedObjectContext) {
        let task = TaskList(context: context)
        task.nameTask = nameGroup
        task.group = group
        
        addToTasks(task)
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения задачи в Core Data \(error)")
        }
    }
    
}

extension NameGroup {
    
    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskList)
    
    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskList)
    
    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)
    
    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
    
}

extension NameGroup : Identifiable {}

