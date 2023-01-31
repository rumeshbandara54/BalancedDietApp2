//
//  SpinnerViewController.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/10/23.
//

import UIKit

class SpinnerViewController: UIViewController {
    
    // add spinner overlay

    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func loadView() {
        
        view = UIView()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.color = .label
        
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
