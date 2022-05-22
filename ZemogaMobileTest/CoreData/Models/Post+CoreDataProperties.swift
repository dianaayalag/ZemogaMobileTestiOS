//
//  Post+CoreDataProperties.swift
//  ZemogaMobileTest
//
//  Created by Diana Ayala on 5/22/22.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var body: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var userId: Int16
    @NSManaged public var commentsRaw: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for commentsRaw
extension Post {

    @objc(addCommentsRawObject:)
    @NSManaged public func addToCommentsRaw(_ value: Comment)

    @objc(removeCommentsRawObject:)
    @NSManaged public func removeFromCommentsRaw(_ value: Comment)

    @objc(addCommentsRaw:)
    @NSManaged public func addToCommentsRaw(_ values: NSSet)

    @objc(removeCommentsRaw:)
    @NSManaged public func removeFromCommentsRaw(_ values: NSSet)

}

extension Post : Identifiable {

}
