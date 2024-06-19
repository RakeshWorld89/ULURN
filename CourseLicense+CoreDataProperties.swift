//
//  CourseLicense+CoreDataProperties.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 10/06/24.
//
//

import Foundation
import CoreData


extension CourseLicense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CourseLicense> {
        return NSFetchRequest<CourseLicense>(entityName: "CourseLicense")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var productName: String?
    @NSManaged public var productId: Int16
    @NSManaged public var lectureCount: Int16
    @NSManaged public var productAuthor: String?
    @NSManaged public var uniqueId: String?

}

extension CourseLicense : Identifiable {

}
