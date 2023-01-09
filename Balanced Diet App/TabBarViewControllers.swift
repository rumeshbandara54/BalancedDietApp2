//
//  TabBarViewController.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class TabBarViewControllers: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
         let vc1 = UINavigationController(rootViewController: HomeViewController())
      let vc2 = UINavigationController(rootViewController: FavouriteViewController())
    
        
        
      vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "bookmark")
   
        
        vc1.title = "Home"
       vc2.title = "Favourite"
     
        
        tabBar.tintColor = .label
    
      
   
       setViewControllers([vc1, vc2], animated: true)
    }

}
