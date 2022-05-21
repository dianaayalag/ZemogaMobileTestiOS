//
//  MainAdapter.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

protocol MainAdapterProtocol {
    var dataSource: [Any] { get set }
    func setTableView(_ tableView: UITableView)
}

class MainAdapter: NSObject, MainAdapterProtocol {
    
    private unowned let mainVC: MainViewControllerProtocol
    
    var dataSource = [Any]()
    
    init(mainVC: MainViewControllerProtocol) {
        self.mainVC = mainVC
    }
    
    func setTableView(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MainAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = self.dataSource[indexPath.row]
        if let post = element as? Post {
            return PostTableViewCell.buildIn(tableView, indexPath: indexPath, post: post)
        } else if let errorMessage = element as? String {
            return ErrorTableViewCell.buildIn(tableView, indexPath: indexPath, errorMessage: errorMessage)
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let postToDelete = self.dataSource[indexPath.row] as? Post else {
            return nil
        }
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.mainVC.deleteSinglePost(postToDelete)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [actionDelete])
        return swipeActions
    }
}

extension MainAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let post = self.dataSource[indexPath.row] as? Post else { return }
        self.mainVC.didSelectPost(post)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataSource[indexPath.row] {
        case is Post: return UITableView.automaticDimension
        case is String: return UITableView.automaticDimension//.frame.height
        default: return 0
        }
    }
}
