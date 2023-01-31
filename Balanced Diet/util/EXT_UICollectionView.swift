//
//  EXT_UICollectionView.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

extension UICollectionView {

    // https://stackoverflow.com/a/48579470
    // Set a message or a spinner on controller views. When data is retriving
    func setEmptyMessage(_ message: String, _ isLoading: Bool) {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        container.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        if (isLoading) {
            let spinner = UIActivityIndicatorView()
            spinner.style = UIActivityIndicatorView.Style.large
            spinner.color = .label
            spinner.startAnimating()
            spinner.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(spinner)
            
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -50),
            ])
        }

        self.backgroundView = container;
    }

    func restore() {
        self.backgroundView = nil
    }
}
