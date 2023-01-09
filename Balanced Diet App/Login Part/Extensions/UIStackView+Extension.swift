//
//  UIStackView+Extension.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/8/23.
//

import UIKit

extension UIView{
    func createStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }
}
