//
//  PostDetailWS.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import Foundation

struct PostDetailWS {
    
    func fetchComments(postId: Int, success: @escaping CommentsDTOHandler, error: @escaping ErrorHandler) {
        
        let urlString = "https://jsonplaceholder.typicode.com/posts/\(postId)/comments"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                error(ZMTErrors.urlNotFound)
            }
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) {(data, response, responseError) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    error(responseError?.localizedDescription != nil ? ZMTErrors.generic(responseError!.localizedDescription) : ZMTErrors.unknownError)
                }
                return
            }
            
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode([CommentDTO].self, from: data) else {
                DispatchQueue.main.async {
                    error(ZMTErrors.generic("Server Error"))
                }
                return
            }
            DispatchQueue.main.async {
                success(response)
            }
        }
        
        task.resume()
    }
    
    func fetchUser(userID: Int, success: @escaping UserDTOHandler, error: @escaping ErrorHandler) {
        
        let urlString = "https://jsonplaceholder.typicode.com/users/\(userID)"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                error(ZMTErrors.urlNotFound)
            }
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) {(data, response, responseError) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    error(responseError?.localizedDescription != nil ? ZMTErrors.generic(responseError!.localizedDescription) : ZMTErrors.unknownError)
                }
                return
            }
            
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(UserDTO.self, from: data) else {
                DispatchQueue.main.async {
                    error(ZMTErrors.generic("Server Error"))
                }
                return
            }
            DispatchQueue.main.async {
                success(response)
            }
        }
        
        task.resume()
    }
}
