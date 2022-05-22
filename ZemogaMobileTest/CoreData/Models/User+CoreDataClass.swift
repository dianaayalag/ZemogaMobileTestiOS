//
//  User+CoreDataClass.swift
//  ZemogaMobileTest
//
//  Created by Diana Ayala on 5/22/22.
//
//

import Foundation
import CoreData


public class User: NSManagedObject {

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
        let user = try User.fetchSingleOrCreate(User.self, id: Int16(userId))
        user.name = dto.name
        user.email = dto.email
        user.phone = dto.phone
        user.website = dto.website
        return user
    }
}

extension User: UniquedObject {
}
