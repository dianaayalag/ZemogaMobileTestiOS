//
//  PostTableViewCell.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var postTitleLabel: UILabel!
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        post.toggleFavorite()
        self.updateData()
    }
    
    private var post: Post! {
        didSet { self.updateData() }
    }
    
    private func updateData() {
        self.postTitleLabel.text = self.post.title
        let buttonImage = self.post.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.favoriteButton.setImage(buttonImage, for: .normal)
    }
}

extension PostTableViewCell {
    
    class func buildIn(_ tableView: UITableView, indexPath: IndexPath, post: Post) -> PostTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell
        cell?.post = post
        return cell ?? PostTableViewCell()
    }
}
