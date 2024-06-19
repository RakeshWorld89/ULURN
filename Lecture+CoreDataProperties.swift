//
//  Lecture+CoreDataProperties.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 19/06/24.
//
//

import Foundation
import CoreData


extension Lecture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lecture> {
        return NSFetchRequest<Lecture>(entityName: "Lecture")
    }

    @NSManaged public var lectureUniqueId: Int64
    @NSManaged public var lectureName: String?
    @NSManaged public var serialNumber: Int32
    @NSManaged public var duration: Double
    @NSManaged public var chapterId: Int16
    @NSManaged public var productId: Int16
    @NSManaged public var sectionId: Int16

}

extension Lecture : Identifiable {

}
