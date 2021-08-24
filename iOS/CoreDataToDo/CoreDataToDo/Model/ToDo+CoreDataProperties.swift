//
//  ToDo+CoreDataProperties.swift
//  CoreDataToDo
//
//  Created by 陈希 on 2021/8/24.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var todoName: String
    @NSManaged public var todoDescription: String
    @NSManaged public var todoImage: Data?
    @NSManaged public var dateCreated: Date

}

extension ToDo : Identifiable {

}
