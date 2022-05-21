//
//  CommentsTableViewCell.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    private var comment: Comment! {
        didSet { self.updateData() }
    }
    
    private func updateData() {
        self.commentLabel.text = self.comment.body
    }
}

extension CommentsTableViewCell {
    
    class func buildIn(_ tableView: UITableView, indexPath: IndexPath, comment: Comment) -> CommentsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell
        cell?.comment = comment
        return cell ?? CommentsTableViewCell()
    }
}
