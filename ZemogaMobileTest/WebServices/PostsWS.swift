//
//  PostsWS.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import Foundation

struct PostsWS {
    func fetchPosts(success: @escaping PostsDTOHandler, error: @escaping ErrorHandler) {
        
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        
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
            guard let response = try? decoder.decode([PostDTO].self, from: data) else {
                DispatchQueue.main.async {
                    error(ZMTErrors.generic("Error en el servicio"))
                }
                return
            }
            DispatchQueue.main.async {
                success(response)
            }
        }
        
        task.resume()
    }
    
    func deleteAllPosts(success: @escaping DeleteHandler, error: @escaping ErrorHandler) {
        
        deletePostWithId(id: nil, success: success, error: error)
        
    }
    
    func deletePostWithId(id: Int?, success: @escaping DeleteHandler, error: @escaping ErrorHandler) {
        
        var urlString = "https://jsonplaceholder.typicode.com/posts"
        
        if let idForUrl = id {
            urlString += "/\(idForUrl)"
        }
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                error(ZMTErrors.urlNotFound)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {(data, response, responseError) in

            guard data != nil else {
                DispatchQueue.main.async {
                    error(responseError?.localizedDescription != nil ? ZMTErrors.generic(responseError!.localizedDescription) : ZMTErrors.unknownError)
                }
                return
            }

            DispatchQueue.main.async {
                success()
            }
        }

        task.resume()
    }
}
