//
//  Comment+CoreDataClass.swift
//  ZemogaMobileTest
//
//  Created by Diana Ayala on 5/22/22.
//
//

import Foundation
import CoreData


public class Comment: NSManagedObject {

}

extension Comment {
    
    class func fetchSingleOrCreate(dto: CommentDTO) throws -> Comment {
        guard let commentId = dto.id else {
            throw ZMTErrors.idNotFound
        }
        let comment = try Comment.fetchSingleOrCreate(Comment.self, id: Int16(commentId))
        comment.postId = Int16(dto.postId ?? -1)
        comment.body = dto.body
        comment.post = try Post.fetchSingleOrCreate(Post.self, id: Int16(comment.postId))
        return comment
    }
}

extension Comment: UniquedObject {
}
