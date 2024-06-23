//
//  CoreDataManager.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 10/06/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    //1
    static let sharedManager = CoreDataManager()
    private init() {}
    
    //2
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ULURNDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        if let url = container.persistentStoreCoordinator.persistentStores.first?.url {
            print("Core Data location: \(url)")
        }
        return container
    }()
    
    //3
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Course License
    
    /*Insert*/
    func insertCourseLicenseDetails(courseLicenseDetails: CourseLicenseDetailsData) {
        
        /*1.
         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
         */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*
         An NSEntityDescription object is associated with a specific class instance
         Class
         NSEntityDescription
         A description of an entity in Core Data.
         
         Retrieving an Entity with a Given Name here person
         */
        let entity = NSEntityDescription.entity(forEntityName: "CourseLicense", in: managedContext)!
        
        /*
         Initializes a managed object and inserts it into the specified managed object context.
         
         init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?)
         */
        let courseLicenseDetailsManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        /*
         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
         */
        courseLicenseDetailsManagedObject.setValue(courseLicenseDetails.userId, forKeyPath: "userId")
        courseLicenseDetailsManagedObject.setValue(courseLicenseDetails.uniqueId, forKeyPath: "uniqueId")
        courseLicenseDetailsManagedObject.setValue(courseLicenseDetails.productId, forKeyPath: "productId")
        courseLicenseDetailsManagedObject.setValue(courseLicenseDetails.productName, forKeyPath: "productName")
        courseLicenseDetailsManagedObject.setValue(courseLicenseDetails.productAuthor, forKeyPath: "productAuthor")
        
        /*
         You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
            try managedContext.save()
            //return courseLicenseDetailsManagedObject as? CourseLicense
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            //return nil
        }
    }
    
    /*delete*/
    func delete(courseLicense: CourseLicense){
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        do {
            managedContext.delete(courseLicense)
        } catch {
            // Do something in response to error condition
            print(error)
        }
        do {
            try managedContext.save()
        } catch {
            // Do something in response to error condition
        }
    }
    
    func fetchAllCourses(userId: Int) -> [CourseLicense]? {
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
         */
        let predicate = NSPredicate(format: "userId == %d", userId)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CourseLicense")
        fetchRequest.predicate = predicate
        
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            let courseLicenseDetailsData = try managedContext.fetch(fetchRequest)
            return courseLicenseDetailsData as? [CourseLicense]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: Lectures
    
    /*Insert*/
    func insertLectureDetails(lectureDetails: LectureDetailsData) {
        
        /*1.
         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
         */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*
         An NSEntityDescription object is associated with a specific class instance
         Class
         NSEntityDescription
         A description of an entity in Core Data.
         
         Retrieving an Entity with a Given Name here person
         */
        let entity = NSEntityDescription.entity(forEntityName: "Lecture", in: managedContext)!
        
        /*
         Initializes a managed object and inserts it into the specified managed object context.
         
         init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?)
         */
        let lectureDetailsManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        /*
         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
         */
        lectureDetailsManagedObject.setValue(lectureDetails.serialNumber, forKeyPath: "serialNumber")
        lectureDetailsManagedObject.setValue(lectureDetails.uniqueId, forKeyPath: "lectureUniqueId")
        lectureDetailsManagedObject.setValue(lectureDetails.productId, forKeyPath: "productId")
        lectureDetailsManagedObject.setValue(lectureDetails.sectionId, forKeyPath: "sectionId")
        lectureDetailsManagedObject.setValue(lectureDetails.chapterId, forKeyPath: "chapterId")
        lectureDetailsManagedObject.setValue(lectureDetails.lectureName, forKeyPath: "lectureName")
        lectureDetailsManagedObject.setValue(lectureDetails.lectureDuration, forKeyPath: "duration")
        
        /*
         You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            //return nil
        }
    }
    
    func fetchAllLectures(chapterId: Int) -> [Lecture]? {
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
         */
        let predicate = NSPredicate(format: "chapterId == %d", chapterId)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lecture")
        fetchRequest.predicate = predicate
        
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            let lectureDetailsData = try managedContext.fetch(fetchRequest)
            return lectureDetailsData as? [Lecture]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchLastLectureId(chapterId: Int) -> Int {
        var lastLectureId = 0
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
         */
        let sortDescriptor = NSSortDescriptor(key: "serialNumber", ascending: false)
        let predicate = NSPredicate(format: "chapterId == %d", chapterId)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lecture")
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            let lectureWithMaximumSerialNumber = try managedContext.fetch(fetchRequest)
            lastLectureId = lectureWithMaximumSerialNumber.first?.value(forKey: "lectureUniqueId") as! Int
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return lastLectureId
        }
        return lastLectureId
    }
    
    func clearAllDataAndResetDB() {
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }
        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print("Attempted to clear persistent store: " + error.localizedDescription)
        }
    }
}
