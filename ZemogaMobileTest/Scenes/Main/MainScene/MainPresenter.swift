//
//  MainPresenter.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

protocol MainPresenterProtocol {
    func didLoad()
    func didAppear()
    func willDisappear()
    func pullToRefresh()
    func prepareForSegue(_ segue: UIStoryboardSegue, post: Post?)
    func deleteAll()
    func deleteSinglePost(id: Int)
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
    
    func pullToRefresh() {
        self.getAllPosts()
    }
    
    func didAppear() {
        self.controller.setUpView()
        self.getAllPosts()
    }
    
    func willDisappear() {
        self.controller.disappearView()
    }
    
    func deleteSinglePost(id: Int) {
        self.deleteOnePost(id: id)
    }
    
    func deleteAll() {
        self.controller.showDeleteAlert{ _ in
            self.deleteAllPosts()
        }
    }
    
    func didLoad() {
        self.controller.setUpView()
        self.controller.configureAdapters()
        self.controller.setUpRefreshView()
        self.getAllPosts()
    }
    
    func prepareForSegue(_ segue: UIStoryboardSegue, post: Post?) {
        if let id = segue.identifier, id == "DetailViewController" {
            let destination = segue.destination as! DetailViewController
            destination.post = post
        }
    }
}

//MARK: - Methods
extension MainPresenter {
    
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
    
    private func deleteAllPosts() {
        self.controller.showLoading(true)
        self.webService.deleteAllPosts {
            self.controller.showLoading(false)
            self.controller.deleteAllPostsFromDataSource()
            self.controller.showAllPostsDeletedAlert()
            do { try Post.deleteAll() } catch {}
        } error: { errorMessage in
            self.controller.showLoading(false)
            self.controller.showCouldntDeletePostsAlert()
        }
    }
    
    private func deleteOnePost(id: Int) {
        self.controller.showLoading(true)
        self.webService.deletePostWithId(id: id) {
            self.controller.showLoading(false)
            do { try Post.deleteSingle(id: id as NSNumber) } catch {}
            self.controller.showPostDeletedAlert()
        } error: { errorMessage in
            self.controller.showLoading(false)
            self.controller.showCouldntDeletePostAlert()
        }
    }
}
