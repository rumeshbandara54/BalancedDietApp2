//
//  UIButton+Extension.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/8/23.
//

import UIKit

extension UIButton {
    public convenience init(title: String, borderColor: UIColor){
        self.init()
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.white]))
        
        self.setAttributedTitle(attributedString, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
      //  self.setAnchor(width: 0, height: 50)
    }
}
