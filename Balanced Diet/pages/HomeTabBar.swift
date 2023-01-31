//
//  HomeTabBar.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class HomeTabBar: UITabBarController, UITabBarControllerDelegate, TypeDelegate {
    
    // Titles for options
    var sectionTitles: [String] = ["FATS", "MEAT", "MILK", "VEGETABLES", "FRUITS", "BAKERY"]
    
    // When clicked on type. New view is pushed from here rather than within the tab to get the new view over tabs.
    func didPressCell(_ item: Int) {
        let nextPage = FoodItemList()
        nextPage.title = sectionTitles[item]
        nextPage.foodType = item
        navigationController?.pushViewController(nextPage, animated: true)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // called when view is about to appear
    override func viewWillAppear(_ animated: Bool) {
        // set nav bar icons depending on user status
        if (UserDefaults.standard.string(forKey: "USERNAME") != nil) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .done, target: self, action: #selector(logout))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(goToLogin))
            // if user is not logged in. First tab is showed
            self.selectedIndex = 0
        }
    }
    
    @objc func goToLogin() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @objc func logout() {
        let refreshAlert = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
            self.selectedIndex = 0
            UserDefaults.standard.removeObject(forKey: "USERNAME")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(self.self.goToLogin))
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.delegate = self
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        let img = UIImage(named: "Logo")!.withRenderingMode(.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // Add view controllers for tabs
        view.backgroundColor = .systemBackground
        let home = HomeViewController()
        home.delegate = self
        home.sectionTitles = sectionTitles
        let vc1 = UINavigationController(rootViewController: home)
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.title = "Home"
        
        let favs = FavouriteViewController()
        let vc2 = UINavigationController(rootViewController: favs)
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        vc2.title = "Favourites"
        
        self.tabBar.backgroundColor = .systemBackground
        self.hidesBottomBarWhenPushed = true
        setViewControllers([vc1, vc2], animated: true)
        self.selectedIndex = 0
    }
    
    // Disable tab swithcing if the user is not logged in
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let username = UserDefaults.standard.string(forKey: "USERNAME")
        if (username == nil) {
            let refreshAlert = UIAlertController(title: "Alert", message: "Please login to view your favourites", preferredStyle: .alert)
            refreshAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
            return false
        }
//        print("bc")
//     navigationController?.setNavigationBarHidden(true, animated: true)
//        UINavigationBar.appearance().backgroundColor = .clear
        
        return true
    }
    
}
