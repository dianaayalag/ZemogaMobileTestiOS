//
//  Post.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import Foundation
import CoreData

class Post: NSManagedObject, UniquedObject {
    
    // Object Data
    @NSManaged var id: NSNumber
    @NSManaged var userId: NSNumber?
    @NSManaged var title: String?
    @NSManaged var body: String?
    @NSManaged var favorite: Bool
    
    // Object Parents
    @NSManaged var user:  User?
    
    // Relationships Data
    @NSManaged var commentsRaw:  NSSet?
    
}

extension Post {
    
    var comments: [Comment]? {
        return commentsRaw?.allObjects as? [Comment]
    }
}

extension Post {
    
    func toggleFavorite() {
        self.favorite = !(self.favorite)
        do { try CoreData.save() } catch {}
    }
}

extension Post {
    
    class func fetchSingleOrCreate(dto: PostDTO) throws -> Post {
        guard let postId = dto.id else {
            throw ZMTErrors.idNotFound
        }
        let post = try Post.fetchSingleOrCreate(Post.self, id: postId as NSNumber)
        post.userId = dto.userId as NSNumber?
        post.title = dto.title
        post.body = dto.body
        
        if let userId = post.userId {
            post.user = try User.fetchSingleOrCreate(User.self, id: userId)
        }
        return post
    }
    
    class func deleteAll() throws {
        let posts = try Post.fetch(Post.self)
        posts.forEach({CoreData.delete(object: $0)})
        try CoreData.save()
    }
    
    class func deleteSingle(id: NSNumber) throws {
        let posts = try Post.fetch(Post.self).filter({$0.id == id})
        posts.forEach({CoreData.delete(object: $0)})
        try CoreData.save()
    }
}
