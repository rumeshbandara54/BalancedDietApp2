//
//  HomeViewController.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

protocol TypeDelegate {
    func didPressCell(_: Int)
}
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sectionTitles: [String]!
    // A delegate class is used to call method in parent class
    var delegate:TypeDelegate!
    
    // home view with types.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView();
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "NutritionTopImg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let categoryTable = UITableView()
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.rowHeight = 50
        categoryTable.sectionHeaderHeight = 20
        categoryTable.sectionFooterHeight = 0
        categoryTable.register(UITableViewCell.self, forCellReuseIdentifier: "catCell")
        categoryTable.translatesAutoresizingMaskIntoConstraints = false
        categoryTable.showsVerticalScrollIndicator = false
      
        /*//16
        if #available(iOS 15.0, *) {
            categoryTable.sectionHeaderTopPadding = 0
        }*/
        
        view.addSubview(imageView)
        view.addSubview(categoryTable)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.73),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.28),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            categoryTable.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            categoryTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoryTable.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            categoryTable.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("hide NavigationBar bar")
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
    }
    
    // call parent function through delegate
    @objc func cellClicked(sender: UIGestureRecognizer) {
        print(sender.view!.tag)
        delegate.didPressCell(sender.view!.tag)
    }
    
    // set table cell text and customize.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        cell.textLabel?.text = sectionTitles[indexPath.section]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.backgroundColor = .systemGray6
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        var tapGesture: UITapGestureRecognizer!
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellClicked(sender:)))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }
    
    // table contain multiple sections. not rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}
