//
//  FoodItemList.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class FoodItemList: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FoodCellDelegate {
    var foodType: Int!
    
    let SPACING:CGFloat = 13.0
    let ITEM_HEIGHT:CGFloat = 250.0
    
    var collectionview: UICollectionView!
    // Unique identifier to identify cells. Which can be used to reuse cells
    let reuseIdentifier = "FoodCell"
    var foodList: [FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionview = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(FoodItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .systemBackground
        
        self.view.addSubview(collectionview)
        
        // fetch and populate data. Bookmarked status is loaded only if user is logged in
        collectionview.setEmptyMessage("Loading Data", true);
        let user = UserDefaults.standard.string(forKey: "USERNAME")
        if (user != nil) {
            APICalls.getFavourites(user!) { (favourites) in
                if (favourites == nil) {
                    let alert = UIAlertController(title: "Alert", message: "Error occurred at server. Please try again later.", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    APICalls.getFoodItems(self.foodType){ (foods) in
                        if (foods == nil) {
                            let alert = UIAlertController(title: "Alert", message: "Error occurred at server. Please try again later.", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            if (foods!.isEmpty) {
                                self.collectionview.setEmptyMessage("No Data to Disaply", false);
                            } else {
                                self.collectionview.restore()
                            }
                            var modifiedFood:[FoodItem] = []
                            for food in foods! {
                                var modFood = FoodItem(id: food.id, foodCategoryId: food.foodCategoryId, foodName: food.foodName, foodImage: food.foodImage, quantity: food.quantity, foodNutritions: food.foodNutritions, foodIngrediants: food.foodIngrediants)
                                for fav in favourites! {
                                    if (fav.foodId == modFood.id) {
                                        modFood.bookMarked = true
                                        modFood.favId = fav.id
                                        break
                                    }
                                }
                                modifiedFood.append(modFood)
                            }
                            self.foodList = modifiedFood
                            self.collectionview.reloadData()
                        }
                    }
                }
            }
        } else {
            APICalls.getFoodItems(foodType){ (foods) in
                if (foods == nil) {
                    let alert = UIAlertController(title: "Alert", message: "Error occurred at server. Please try again later.", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if (foods!.isEmpty) {
                        self.collectionview.setEmptyMessage("No Data to Disaply", false);
                    } else {
                        self.collectionview.restore()
                    }
                    var modifiedFood:[FoodItem] = []
                    for food in foods! {
                        let modFood = FoodItem(id: food.id, foodCategoryId: food.foodCategoryId, foodName: food.foodName, foodImage: food.foodImage, quantity: food.quantity, foodNutritions: food.foodNutritions, foodIngrediants: food.foodIngrediants)
                        modifiedFood.append(modFood)
                    }
                    self.foodList = modifiedFood
                    self.collectionview.reloadData()
                }
            }
        }
    }
    
    // Handle screen rotation event
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionview.frame = view.bounds
        collectionview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FoodItemCell
        cell.foodItem = foodList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    // Add spacings to cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: SPACING, left: SPACING, bottom: SPACING, right: SPACING)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SPACING
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return SPACING
    }
    
    // calculate height and width for each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = itemWidth(for: view.frame.width, spacing: 0)
        
        return CGSize(width: width, height: ITEM_HEIGHT)
    }
    
    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2
        
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        
        return finalWidth - 20
    }
    
    // handle requests from child cells
    func didPressCell(_ sender: FoodItem) {
        let nextView = FoodDetailViewController()
        nextView.foodItem = sender
        navigationController?.pushViewController(nextView, animated: true)
    }
    
    func askToLogin() {
        let refreshAlert = UIAlertController(title: "Alert", message: "Please login to add this item to favourites", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showError() {
        let refreshAlert = UIAlertController(title: "Error", message: "Error ocurred. Please try again later.", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    // Called when view is abbout to appear. Data is reloaded as children can manipulate data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadView()
        
        if (UserDefaults.standard.string(forKey: "USERNAME") != nil) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .done, target: self, action: #selector(logout))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(goToLogin))
        }
    }
    
    @objc func goToLogin() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @objc func logout() {
        let refreshAlert = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { [self] (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "USERNAME")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(goToLogin))
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    // Data is reloaded. Only favourite list is needed
    func reloadView() {
        let user = UserDefaults.standard.string(forKey: "USERNAME")
        if (user == nil) {
            var modifiedFood:[FoodItem] = []
            for var food in self.foodList {
                food.favId = nil
                food.bookMarked = false
                modifiedFood.append(food)
            }
            self.foodList = modifiedFood
            self.collectionview.reloadData()
            return
        }
        APICalls.getFavourites(user!) { (favourites) in
            if (favourites == nil) {
                let alert = UIAlertController(title: "Alert", message: "Error occurred at server. Please try again later.", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            } else {
                var modifiedFood:[FoodItem] = []
                for var food in self.foodList {
                    var flag = -1
                    for fav in favourites! {
                        if (fav.foodId == food.id) {
                            flag = fav.id
                            break
                        }
                    }
                    if (flag == -1) {
                        food.favId = nil
                        food.bookMarked = false
                    } else {
                        food.favId = flag
                        food.bookMarked = true
                    }
                    modifiedFood.append(food)
                }
                self.foodList = modifiedFood
                self.collectionview.reloadData()
            }
        }
    }
    
}
