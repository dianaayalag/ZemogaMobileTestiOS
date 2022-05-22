//
//  MainPresenter.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

protocol MainPresenterProtocol {
    func didAppear()
    func didLoad()
    func willAppear()
    func prepareForSegue(_ segue: UIStoryboardSegue, post: Post?)
    func deleteAll()
    func deleteSinglePost(_ post: Post)
    func pullToRefresh(shouldRefresh: Bool)
}

struct MainPresenter {
    
    private unowned let controller: MainViewControllerProtocol
    private let webService = PostsWS()
    
    init(controller: MainViewControllerProtocol) {
        self.controller = controller
    }
}

//MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    
    // MARK: Controller lifecycle events
    
    func didAppear() {
        self.controller.setUpView()
        self.getAllPosts()
    }
    
    func didLoad() {
        self.controller.setUpView()
        self.controller.configureAdapters()
        self.controller.setUpRefreshView()
        self.getAllPosts()
    }
    
    func willAppear() {
        self.controller.appearView()
    }
    
    // MARK: Navigation events
    
    func prepareForSegue(_ segue: UIStoryboardSegue, post: Post?) {
        if let id = segue.identifier, id == "DetailViewController" {
            let destination = segue.destination as! DetailViewController
            destination.post = post
        }
    }
    
    // MARK: Other events
    
    func deleteAll() {
        self.controller.showDeleteAlert{ _ in
            self.deleteAllPosts()
        }
    }
    
    func deleteSinglePost(_ post: Post) {
        self.deletePost(post)
    }
    
    func pullToRefresh(shouldRefresh: Bool) {
        if shouldRefresh {
            self.getAllPosts()
        } else {
            self.controller.showLoading(false)
        }
    }
}

//MARK: - Methods
extension MainPresenter {
    
    private func deleteAllPosts() {
        self.controller.showLoading(true)
        self.webService.deleteAllPosts {
            self.controller.showLoading(false)
            self.controller.deleteAllPostsFromDataSource()
            self.controller.showAllPostsDeletedAlert()
            do {
                try Post.deleteAll()
            } catch {
                self.controller.showCouldntDeletePostsAlert()
            }
        } error: { errorMessage in
            self.controller.showLoading(false)
            self.controller.showCouldntDeletePostsAlert()
        }
    }
    
    private func deletePost(_ post: Post) {
        self.controller.showLoading(true)
        self.webService.deletePostWithId(id: Int(post.id)) {
            self.controller.showLoading(false)
            do {
                try Post.deletePost(post)
            } catch {
                self.controller.showCouldntDeletePostAlert()
            }
            self.controller.showPostDeletedAlert()
        } error: { errorMessage in
            self.controller.showLoading(false)
            self.controller.showCouldntDeletePostAlert()
        }
    }
    
    private func getAllPosts() {
        self.controller.showLoading(true)
        self.webService.fetchPosts { postDTO in
            self.controller.showLoading(false)
            var postsArray = postDTO.toPosts
            postsArray.sort{
                $0.favorite && !$1.favorite
            }
            let arrayToShow: [Any] = postsArray.count != 0 ? postsArray : ["We couldn't find any posts"]
            self.controller.reloadTableWithData(arrayToShow)
            self.controller.setFilterAdapterDataSource(arrayToShow)
        } error: { errorMessage in
            self.controller.showLoading(false)
            self.controller.reloadTableWithData([errorMessage])
        }
    }
}
