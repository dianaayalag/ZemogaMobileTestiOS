//
//  UserResponse.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import Foundation

struct UserDTO: Decodable {
    let id: Int?
    let name: String?
    let email: String?
    let phone: String?
    let website: String?
}

extension UserDTO {
    var toUser: User {
        do {return try User.fetchSingleOrCreate(dto: self)} catch {return User()}
    }
}
