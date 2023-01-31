//
//  FavouriteViewController.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class FavouriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FoodCellDelegate {
    let SPACING: CGFloat = 13.0
    let ITEM_HEIGHT: CGFloat = 250.0
    
    var collectionview: UICollectionView!
    let reuseIdentifier = "FoodCell"
    var foodList: [FoodItem] = []
    let hider = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // CollectionView is used to display tiles. Using a flow layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        collectionview = UICollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(FoodItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .systemBackground
        
       // hider.backgroundColor = .red
      //  hider.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(collectionview)
       // view.addSubview(hider)
        
       /* NSLayoutConstraint.activate([
            hider.topAnchor.constraint(equalTo: view.topAnchor),
            hider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hider.leftAnchor.constraint(equalTo: view.leftAnchor),
            hider.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])*/
        
        // Load data and set bookmarked status for loaded items
        collectionview.setEmptyMessage("Loading Data", true);
        let user = UserDefaults.standard.string(forKey: "USERNAME")
        if (user != nil) {
            APICalls.getFavourites(user!) { (favourites) in
                if (favourites == nil) {
                    let alert = UIAlertController(title: "Alert", message: "Error occurred at server. Please try again later.", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    APICalls.getFoodItems(99){ (foods) in
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
                                if (modFood.bookMarked) {
                                    modifiedFood.append(modFood)
                                }
                            }
                            self.foodList = modifiedFood
                            self.collectionview.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // handle screen rotation events
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionview.frame = view.bounds
        collectionview.reloadData()
    }
    
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    // Each cell is a custom cell. Which is defined in a separate file
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FoodItemCell
        cell.foodItem = foodList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    // set spacings for application
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: SPACING, left: SPACING, bottom: SPACING, right: SPACING)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SPACING
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return SPACING
    }
    
    // calculate item height for each cell
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
    
    // function to handle actions in child cells
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
    
    // Before showing child again. Data is refreshed as data can be manipulated in child views
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hider.isHidden = true
    }
    
    // Function to get and populate data.
    func reloadView() {
        self.foodList = []
        self.collectionview.reloadData()
        collectionview.setEmptyMessage("Loading Data", true);
        let user = UserDefaults.standard.string(forKey: "USERNAME")
        if (user != nil) {
            APICalls.getFavourites(user!) { (favourites) in
                if (favourites == nil) {
                    let alert = UIAlertController(title: "Alert", message: "Error occurred at server. Please try again later.", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    APICalls.getFoodItems(99){ (foods) in
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
                                if (modFood.bookMarked) {
                                    modifiedFood.append(modFood)
                                }
                            }
                            self.foodList = modifiedFood
                            self.collectionview.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}
