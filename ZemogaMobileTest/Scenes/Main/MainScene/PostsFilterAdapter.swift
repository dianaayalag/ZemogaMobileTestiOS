//
//  PostsFilterAdapter.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

protocol PostsFilterAdapterProtocol {
    var dataSource: [Post] { get set }
    func deletePost(_ post: Post)
    func filterByFavorites(favorites: Bool)
}

class PostsFilterAdapter: NSObject, PostsFilterAdapterProtocol {
    
    private unowned let mainVC: MainViewControllerProtocol
    
    var dataSource = [Post]()
    
    init(mainVC: MainViewControllerProtocol) {
        self.mainVC = mainVC
    }
}

extension PostsFilterAdapter {
    
    func deletePost(_ post: Post) {
        self.dataSource.removeAll(where: { $0.id == post.id })
    }
    
    func filterByFavorites(favorites: Bool) {
        if !favorites {
            self.mainVC.didFilterWithResult(self.dataSource)
        } else {
            var result: [Any] = self.dataSource.filter{
                $0.favorite
            }
            result = result.count != 0 ? result : ["We couldn't find any favorite posts"]
            self.mainVC.didFilterWithResult(result)
        }
    }
}
