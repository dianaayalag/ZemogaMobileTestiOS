//
//  MainRouter.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import UIKit

protocol MainRouterProtocol {
    func navigateToDetailForPost(_ post: Post)
}

class MainRouter {
    
    private unowned let mainVC: MainViewControllerProtocol
    
    init(mainVC: MainViewControllerProtocol) {
        self.mainVC = mainVC
    }
    
}

extension MainRouter: MainRouterProtocol {
    
    func navigateToDetailForPost(_ post: Post) {
        mainVC.presentDetailVC()
    }
    
}

