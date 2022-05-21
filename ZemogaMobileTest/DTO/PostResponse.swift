//
//  PostResponse.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import Foundation

struct PostDTO: Decodable {
    let id: Int?
    let userId: Int?
    let title: String?
    let body: String?
}

extension PostDTO {
    var toPost: Post {
        do {return try Post.fetchSingleOrCreate(dto: self)} catch {return Post()}
    }
}

extension Array where Element == PostDTO {
    var toPosts: [Post] {
        self.map({ $0.toPost })
    }
}

