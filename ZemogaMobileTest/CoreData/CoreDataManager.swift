//
//  CoreDataManager.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import Foundation
import CoreData

open class CoreData {
    
    private static var _applicationDocumentsDirectory: URL?
    private static func applicationDocumentsDirectory() -> URL {
        if _applicationDocumentsDirectory == nil {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            _applicationDocumentsDirectory = urls[urls.count-1]
        }
        return _applicationDocumentsDirectory!
    }
    
    private static var _managedObjectModel: NSManagedObjectModel?
    private static func managedObjectModel() -> NSManagedObjectModel {
        if _managedObjectModel == nil {
            let modelURL = Bundle.main.url(forResource: "CoreData", withExtension: "momd")!
            _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        }
        return _managedObjectModel!
    }
    
    private static var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private static func persistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        if _persistentStoreCoordinator == nil {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel())
            let url = applicationDocumentsDirectory().appendingPathComponent("CoreData.sqlite")
            let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
            _persistentStoreCoordinator = coordinator
        }
        return _persistentStoreCoordinator!
    }
    
    private static var _managedObjectContext: NSManagedObjectContext?
    private static func managedObjectContext() -> NSManagedObjectContext {
        if _managedObjectContext == nil {
            let managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator()
            _managedObjectContext = managedObjectContext
        }
        return _managedObjectContext!
    }
    
}

extension CoreData {
    
    public class func create(entityName: String) -> NSManagedObject {
        let managedContext = managedObjectContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let newEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        return newEntity
    }
    
    public class func save() throws {
        let managedContext = managedObjectContext()
        guard managedContext.hasChanges else {
            return
        }
        try managedContext.save()
    }
    
    open class func delete(object: NSManagedObject) {
        let managedContext = managedObjectContext()
        managedContext.delete(object)
    }
    
    open class func fetch<T : NSFetchRequestResult>(_ entity: T.Type, entityName: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let managedContext = managedObjectContext()
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        let objects = try managedContext.fetch(fetchRequest)
        return objects
    }
}

public extension NSManagedObject {
    
    class func create<T:NSManagedObject>(_ entity: T.Type) -> T {
        return CoreData.create(entityName: T.className) as! T
    }
    
    class func create<T:NSManagedObject>(_ entity: T.Type, id: NSNumber) -> T where T:UniquedObject {
        var obj = create(entity)
        obj.id = id
        return obj
    }
    
    class func fetch<T:NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        return try CoreData.fetch(entity, entityName: T.className, predicate: predicate, sortDescriptors: sortDescriptors)
    }
    
    class func fetchSingle<T:NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil) throws -> T? {
        return try fetch(entity, predicate: predicate).first
    }
    
    class func fetchSingle<T:NSManagedObject>(_ entity: T.Type, id: NSNumber) throws -> T? where T:UniquedObject {
        return try fetchSingle(entity, predicate: NSPredicate(format: "id == %@", id))
    }
    
    class func fetchSingleOrCreate<T:NSManagedObject>(_ entity: T.Type, id: NSNumber) throws -> T where T:UniquedObject {
        return try fetchSingle(entity, id: id) ?? create(entity, id: id)
    }
    
    func delete() {
        CoreData.delete(object: self)
    }
    
    func save() throws {
        try CoreData.save()
    }
    
}

public protocol UniquedObject {
    var id: NSNumber { get set }
}

extension NSManagedObject: ClassNameable { }

public protocol ClassNameable: AnyObject {
    
    static var className: String { get }
    
    var className: String { get }
    
}

public extension ClassNameable {
    
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return type(of: self).className
    }
    
}
