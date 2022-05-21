//
//  ErrorTableViewCell.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var errorMessageLabel: UILabel!
    
    private var errorMessage: String! {
        didSet { self.updateData() }
    }
    
    private func updateData() {
        self.errorMessageLabel.text = self.errorMessage
    }
}

extension ErrorTableViewCell {
    
    class func buildIn(_ tableView: UITableView, indexPath: IndexPath, errorMessage: String) -> ErrorTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorTableViewCell", for: indexPath) as? ErrorTableViewCell
        cell?.errorMessage = errorMessage
        return cell ?? ErrorTableViewCell()
    }
}
