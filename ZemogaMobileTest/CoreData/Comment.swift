//
//  Detail.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import Foundation
import CoreData

class Comment: NSManagedObject, UniquedObject {
    
    // Object Data
    @NSManaged var id: NSNumber
    @NSManaged var postId: NSNumber?
    @NSManaged var body: String?
    
    // Object Parents
    @NSManaged var post: Post?
    
}

extension Comment {
    
    class func fetchSingleOrCreate(dto: CommentDTO) throws -> Comment {
        
        guard let commentId = dto.id else {
            throw ZMTErrors.idNotFound
        }
        
        let comment = try Comment.fetchSingleOrCreate(Comment.self, id: commentId as NSNumber)
        comment.postId = dto.postId as NSNumber?
        comment.body = dto.body
        
        if let postId = comment.postId {
            comment.post = try Post.fetchSingleOrCreate(Post.self, id: postId)
        }
        
        return comment
    }
    
}
