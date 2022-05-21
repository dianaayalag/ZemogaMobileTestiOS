//
//  DetailAdapter.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import UIKit

protocol DetailAdapterProtocol {
    var dataSource: [Any] { get set }
    func setTableView(_ tableView: UITableView)
}

class DetailAdapter: NSObject, DetailAdapterProtocol {
    
    private unowned let detailVC: DetailViewControllerProtocol
    
    var dataSource = [Any]()
    
    init(detailVC: DetailViewControllerProtocol) {
        self.detailVC = detailVC
    }
    
    func setTableView(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension DetailAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comments"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = self.dataSource[indexPath.row]
        if let comment = element as? Comment {
            return CommentsTableViewCell.buildIn(tableView, indexPath: indexPath, comment: comment)
        } else if let errorMessage = element as? String {
            return ErrorTableViewCell.buildIn(tableView, indexPath: indexPath, errorMessage: errorMessage)
        } else {
            return UITableViewCell()
        }
    }
}

extension DetailAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataSource[indexPath.row] {
        case is Comment: return UITableView.automaticDimension
        case is String: return tableView.frame.height
        default: return 0
        }
    }
}
