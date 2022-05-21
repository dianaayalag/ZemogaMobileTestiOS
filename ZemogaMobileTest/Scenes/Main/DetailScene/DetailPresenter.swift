//
//  DetailPresenter.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import UIKit

protocol DetailPresenterProtocol {
    func didLoad(post: Post?)
    func willDisappear()
    func pullToRefresh(post: Post?)
}

struct DetailPresenter {
    
    private unowned let controller: DetailViewControllerProtocol
    private let webService = PostDetailWS()
    
    init(controller: DetailViewControllerProtocol) {
        self.controller = controller
    }
}

//MARK: - DetailPresenterProtocol
extension DetailPresenter: DetailPresenterProtocol {
    
    func didLoad(post: Post?) {
        self.controller.configureAdapters()
        self.controller.setUpView()
        self.controller.displayPostInfo(post)
        if let userId = post?.userId {
            self.getUser(nid: userId)
        }
        if let postId = post?.id {
            self.getComments(nid: postId)
        }
    }
    
    func willDisappear() {
        self.controller.disappearView()
    }
    
    func pullToRefresh(post: Post?) {
        if let userId = post?.userId {
            self.getUser(nid: userId)
        }
        if let postId = post?.id {
            self.getComments(nid: postId)
        }
    }

}

//MARK: - Methods
extension DetailPresenter {
    
    private func getUser(nid: NSNumber) {
        self.controller.showLoading(true)
        let id = Int(truncating: nid)
        self.webService.fetchUser(userID: id) { userDTO in
            self.controller.showLoading(false)
            let user = userDTO.toUser
            self.controller.displayUser(user)
        } error: { errorMessage in
            self.controller.showLoading(false)
        }
    }
    
    private func getComments(nid: NSNumber) {
        self.controller.showLoading(true)
        let id = Int(truncating: nid)
        self.webService.fetchComments(postId: id) { commentsDTO in
            self.controller.showLoading(false)
            let commentsArray = commentsDTO.toComments
            let arrayToShow: [Any] = commentsArray.count != 0 ? commentsArray : ["We couldn't find any comments"]
            self.controller.reloadTableWithData(arrayToShow)
        } error: { errorMessage in
            self.controller.showLoading(false)
            self.controller.reloadTableWithData([errorMessage])
        }
    }
}
