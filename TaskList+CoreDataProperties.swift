//
//  TaskList+CoreDataProperties.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 09.11.2024.
//
//

import Foundation
import CoreData

@objc(TaskList)
public class TaskList: NSManagedObject {}

extension TaskList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskList> {
        return NSFetchRequest<TaskList>(entityName: "TaskList")
    }

    @NSManaged public var nameTask: String?
    @NSManaged public var date: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var group: NameGroup?

}

// MARK: Generated accessors for group
extension TaskList {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: NameGroup)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: NameGroup)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}

extension TaskList : Identifiable {}
