//
//  User+CoreDataProperties.swift
//  ZemogaMobileTest
//
//  Created by Diana Ayala on 5/22/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var website: String?
    @NSManaged public var postsRaw: NSSet?

}

// MARK: Generated accessors for postsRaw
extension User {

    @objc(addPostsRawObject:)
    @NSManaged public func addToPostsRaw(_ value: Post)

    @objc(removePostsRawObject:)
    @NSManaged public func removeFromPostsRaw(_ value: Post)

    @objc(addPostsRaw:)
    @NSManaged public func addToPostsRaw(_ values: NSSet)

    @objc(removePostsRaw:)
    @NSManaged public func removeFromPostsRaw(_ values: NSSet)

}

extension User : Identifiable {

}
