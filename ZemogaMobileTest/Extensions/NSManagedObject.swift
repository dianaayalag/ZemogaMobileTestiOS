//
//  NSManagedObject.swift
//  ZemogaMobileTest
//
//  Created by Diana Ayala on 5/22/22.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
    class func create<T:NSManagedObject>(_ entity: T.Type) -> T {
        let entityName = T.className
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: CoreDataManager.shared.persistentContainer.viewContext)!
        let newEntity = NSManagedObject(entity: entity, insertInto: CoreDataManager.shared.persistentContainer.viewContext)
        return newEntity as! T
    }
    
    class func create<T:NSManagedObject>(_ entity: T.Type, id: Int16) -> T where T:UniquedObject {
        var newEntity = create(entity)
        newEntity.id = id
        return newEntity
    }
    
    class func fetch<T:NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.className)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return try CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
    }
    
    class func fetchSingle<T:NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil) throws -> T? {
        return try fetch(entity, predicate: predicate).first
    }
    
    class func fetchSingle<T:NSManagedObject>(_ entity: T.Type, id: Int16) throws -> T? where T:UniquedObject {
        return try fetchSingle(entity, predicate: NSPredicate(format: "id == %d", id))
    }
    
    class func fetchSingleOrCreate<T:NSManagedObject>(_ entity: T.Type, id: Int16) throws -> T where T:UniquedObject {
        return try fetchSingle(entity, id: id) ?? create(entity, id: id)
    }
    
    func delete() {
        CoreDataManager.shared.persistentContainer.viewContext.delete(self)
    }
}

extension NSManagedObject: ClassNameable { }

// MARK: Protocols

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

public protocol UniquedObject {
    var id: Int16 { get set }
}
