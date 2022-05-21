//
//  SegmentedControlExtensions.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

extension UISegmentedControl {
    
    func setAppearanceWithColor(_ color: UIColor) {
        self.selectedSegmentTintColor = color
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }

}
