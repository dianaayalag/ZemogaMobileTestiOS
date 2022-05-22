//
//  Post+CoreDataClass.swift
//  ZemogaMobileTest
//
//  Created by Diana Ayala on 5/22/22.
//
//

import Foundation
import CoreData


public class Post: NSManagedObject {
}

extension Post {
    
    var comments: [Comment]? {
        return commentsRaw?.allObjects as? [Comment]
    }
}

extension Post {
    
    func toggleFavorite() {
        self.favorite.toggle()
        CoreDataManager.shared.saveContext()
    }
}

extension Post {
    
    class func fetchSingleOrCreate(dto: PostDTO) throws -> Post {
        guard let postId = dto.id else {
            throw ZMTErrors.idNotFound
        }
        let post = try Post.fetchSingleOrCreate(Post.self, id: Int16(postId))
        post.userId = Int16(dto.userId ?? -1)
        post.title = dto.title
        post.body = dto.body
        post.user = try User.fetchSingleOrCreate(User.self, id: post.userId)
        return post
    }
    
    class func deleteAll() throws {
        let posts = try Post.fetch(Post.self)
        posts.forEach({ $0.delete() })
        CoreDataManager.shared.saveContext()
    }
    
    class func deletePost(_ post: Post) throws {
        post.delete()
        CoreDataManager.shared.saveContext()
    }
}

extension Post: UniquedObject {
}
