//
//  Closures.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

typealias PostsDTOHandler = (_ PostsDTO: [PostDTO]) -> Void
typealias CommentsDTOHandler = (_ CommentsDTO: [CommentDTO]) -> Void
typealias UserDTOHandler = (_ USerDTO: UserDTO) -> Void
typealias ActionHandler = (UIAlertAction) -> Void
typealias DeleteHandler = () -> Void
typealias ErrorHandler = (_ errorMessage: LocalizedError) -> Void
