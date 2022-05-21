//
//  User.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import Foundation
import CoreData

class User: NSManagedObject, UniquedObject {
    
    // Object Data
    @NSManaged var id: NSNumber
    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var website: String?
    
    // Relationships Data
    @NSManaged var postsRaw:  NSSet?
    
}

extension User {
    
    var posts: [Post]? {
        return postsRaw?.allObjects as? [Post]
    }
    
}
extension User {
    
    class func fetchSingleOrCreate(dto: UserDTO) throws -> User {
        
        guard let userId = dto.id else {
            throw ZMTErrors.idNotFound
        }
        
        let user = try User.fetchSingleOrCreate(User.self, id: userId as NSNumber)
        user.name = dto.name
        user.email = dto.email
        user.phone = dto.phone
        user.website = dto.website
        
        return user
    }
    
}

