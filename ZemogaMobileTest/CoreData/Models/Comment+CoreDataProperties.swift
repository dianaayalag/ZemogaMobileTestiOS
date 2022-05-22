//
//  Comment+CoreDataProperties.swift
//  ZemogaMobileTest
//
//  Created by Diana Ayala on 5/22/22.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: Int16
    @NSManaged public var postId: Int16
    @NSManaged public var post: Post?

}

extension Comment : Identifiable {

}
