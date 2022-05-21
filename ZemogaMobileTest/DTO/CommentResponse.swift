//
//  DetailResponse.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import Foundation

struct CommentDTO: Decodable {
    let id: Int?
    let postId: Int?
    let body: String?
}

extension CommentDTO {
    var toComment: Comment {
        do {return try Comment.fetchSingleOrCreate(dto: self)} catch {return Comment()}
    }
}

extension Array where Element == CommentDTO {
    var toComments: [Comment] {
        self.map({ $0.toComment })
    }
}
