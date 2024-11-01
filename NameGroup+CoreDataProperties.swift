//
//  NameGroup+CoreDataProperties.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 01.11.2024.
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
}

extension NameGroup : Identifiable {}
