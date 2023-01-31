//
//  FoodItemCell.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

protocol FoodCellDelegate {
    func didPressCell(_ sender: FoodItem)
    func askToLogin()
    func showError()
    func reloadView()
}
class FoodItemCell: UICollectionViewCell {
    
    // custom cell to display items
    
    var delegate:FoodCellDelegate!
    let text = UILabel()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let button = UIImageView()
    let imageView = UIImageView(image: UIImage(systemName: "fork.knife")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal))
    
    var foodItem:FoodItem? {
        // didset is called when value is passed by the parent class
        didSet {
            text.text = foodItem?.foodName
            imageView.image = convertBase64StringToImage(imageBase64String: foodItem?.foodImage ?? "")
            imageView.contentMode = .scaleAspectFill
            if (foodItem != nil && foodItem!.bookMarked) {
                let icon = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
                button.image = icon
            } else {
                let icon = UIImage(systemName: "heart")?.withTintColor(.label, renderingMode: .alwaysOriginal)
                button.image = icon
            }
        }
    }
    
    // base64 string to image converter
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellClicked))
        addGestureRecognizer(tapGesture)
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.numberOfLines = 0
        text.font = .boldSystemFont(ofSize: 20)
        container.addSubview(text);
        
        contentView.layer.borderColor = UIColor.systemGray3.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 6
        contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        let favGesture = UITapGestureRecognizer(target: self, action: #selector(favouriteClicked))
        
        let btnContaoner = UIView()
        btnContaoner.addGestureRecognizer(favGesture)
        btnContaoner.translatesAutoresizingMaskIntoConstraints = false
        btnContaoner.layer.cornerRadius = 15
        btnContaoner.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnContaoner.backgroundColor = .systemGray6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        btnContaoner.addSubview(button)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = UIColor(white: 0, alpha: 0.5)
        spinner.color = .white
        spinner.addGestureRecognizer(UITapGestureRecognizer())
        
        contentView.addSubview(imageView)
        contentView.addSubview(container)
        contentView.addSubview(btnContaoner)
        contentView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            
            container.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            container.leftAnchor.constraint(equalTo: leftAnchor, constant: 3),
            container.rightAnchor.constraint(equalTo: rightAnchor, constant: -3),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            text.widthAnchor.constraint(equalTo: container.widthAnchor),
            text.heightAnchor.constraint(equalTo: container.heightAnchor),
            text.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            btnContaoner.rightAnchor.constraint(equalTo: rightAnchor),
            btnContaoner.centerYAnchor.constraint(equalTo: imageView.bottomAnchor),
            btnContaoner.widthAnchor.constraint(equalToConstant: 34),
            btnContaoner.heightAnchor.constraint(equalToConstant: 34),
            
            button.topAnchor.constraint(equalTo: btnContaoner.topAnchor, constant: 2),
            button.bottomAnchor.constraint(equalTo: btnContaoner.bottomAnchor, constant: -2),
            button.leftAnchor.constraint(equalTo: btnContaoner.leftAnchor, constant: 2),
            button.rightAnchor.constraint(equalTo: btnContaoner.rightAnchor, constant: -2),
            
            spinner.topAnchor.constraint(equalTo: topAnchor),
            spinner.bottomAnchor.constraint(equalTo: bottomAnchor),
            spinner.leftAnchor.constraint(equalTo: leftAnchor),
            spinner.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func cellClicked() {
        delegate.didPressCell(foodItem!)
    }
    
    // favourite button action
    @objc func favouriteClicked() {
        let username:String? = UserDefaults.standard.string(forKey: "USERNAME")
        if (username == nil) {
            self.delegate.askToLogin()
        } else {
            spinner.startAnimating()
            if (self.foodItem!.bookMarked) {
                APICalls.removeFavourite(foodItem!.favId!, username!) { (result) in
                    self.spinner.stopAnimating()
                    if (result) {
                        self.delegate.reloadView()
                    } else {
                        self.delegate.showError()
                    }
                }
            } else {
                APICalls.createFavourite(foodItem!.id, foodItem!.foodName, username!){ (result) in
                    self.spinner.stopAnimating()
                    if (result) {
                        self.delegate.reloadView()
                    } else {
                        self.delegate.showError()
                    }
                }
            }
        }
    }
    
}
