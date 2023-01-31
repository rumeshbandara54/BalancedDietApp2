//
//  FoodDetailViewController.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

// Display food details and nutrional values
class FoodDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let scrollView = UIScrollView()
    
    var collectionview1: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let scrollView1 = UIScrollView()
    
    var collectionview2: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let scrollView2 = UIScrollView()
    
    let nutriCellID1 = "nutriCellID1"
    let nutriCellID2 = "nutriCellID2"
    let SPACING:CGFloat = 0.0
    let ROW_COUNT:CGFloat = 3
    
    let foodName = UILabel()
    let quntityLabel = UILabel()
    let ingredInfo = UILabel()
    let favouriteBtn = UIButton()
    let imageView = UIImageView(image: UIImage(systemName: "fork.knife")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal))
    
    var nutriData: [FoodCellDTO] = []
    var ingredData: [FoodCellDTO] = []
    
    var foodItem:FoodItem? {
        didSet {
            foodName.text = foodItem?.foodName
            quntityLabel.text = "(Quantity : \(foodItem?.quantity ?? 0)g)"
            setButtonLabel()
            imageView.image = convertBase64StringToImage(imageBase64String: foodItem?.foodImage ?? "")
            imageView.contentMode = .scaleAspectFill
            
            // Set table 1 nutrional details
            var nutriName: [String] = []
            var nutriserveAmount: [String] = []
            var nutriAmount: [String] = []
            for nutri in foodItem!.foodNutritions {
                nutriName.append("  \(nutri.nutritionName)")
                nutriserveAmount.append("\(nutri.servingAmount) mg")
                nutriAmount.append("\(nutri.nutritionAmount)%")
            }
            let item1 = FoodCellDTO(header: "Nutrition", data: nutriName, allignment: .left)
            let item2 = FoodCellDTO(header: "Size Per Serve", data: nutriserveAmount, allignment: .center)
            let item3 = FoodCellDTO(header: "Daily Value", data: nutriAmount, allignment: .center)
            
            nutriData.append(item1)
            nutriData.append(item2)
            nutriData.append(item3)
            
            // Second Table ingrediant details
            var ingredName: [String] = []
            var ingredserveAmount: [String] = []
            var ingredAmount: [String] = []
            for ingred in foodItem!.foodIngrediants {
                ingredName.append("  \(ingred.ingrediantName)")
                ingredserveAmount.append("\(ingred.servingAmount) g")
                ingredAmount.append("\(ingred.caloryAmount) cal")
            }
            let itemIng1 = FoodCellDTO(header: "Ingredient", data: ingredName, allignment: .left)
            let itemIng2 = FoodCellDTO(header: "Serving Amount", data: ingredserveAmount, allignment: .center)
            let itemIng3 = FoodCellDTO(header: "Calories", data: ingredAmount, allignment: .center)
            print(ingredName)
            ingredData.append(itemIng1)
            ingredData.append(itemIng2)
            ingredData.append(itemIng3)
            
            let layout1 = UICollectionViewFlowLayout()
            layout1.itemSize = CGSize(width: 150, height: ((nutriName.count + 1) * 25))
            layout1.scrollDirection = .horizontal
            
            let layout2 = UICollectionViewFlowLayout()
            layout2.itemSize = CGSize(width: 150, height: ((ingredName.count + 1) * 25))
            layout2.scrollDirection = .horizontal
            
            collectionview1 = UICollectionView(frame: CGRect(x: 0, y: 0, width: 450, height: ((nutriName.count + 1) * 25)), collectionViewLayout: layout1)
            
            scrollView1.contentSize = CGSize(width: 450, height: ((nutriName.count + 1) * 25))
            scrollView1.heightAnchor.constraint(equalToConstant: CGFloat((nutriName.count + 1) * 25)).isActive = true
            collectionview1.heightAnchor.constraint(equalToConstant: CGFloat((nutriName.count + 1) * 25)).isActive = true
            
            collectionview2 = UICollectionView(frame: CGRect(x: 0, y: 0, width: 450, height: ((ingredName.count + 1) * 25)), collectionViewLayout: layout2)
            
            scrollView2.contentSize = CGSize(width: 450, height: ((ingredName.count + 1) * 25))
            // IF ingrediants are unavailable view is hidden.
            if (ingredName.count == 0) {
                ingredInfo.isHidden = true
                scrollView2.isHidden = true
            }
            scrollView2.heightAnchor.constraint(equalToConstant: CGFloat((ingredName.count + 1) * 25)).isActive = true
            collectionview2.heightAnchor.constraint(equalToConstant: CGFloat((ingredName.count + 1) * 25)).isActive = true
        }
    }
    
    // Seperate function to set button label depending on bookmarked status
    func setButtonLabel() {
        if (foodItem!.bookMarked) {
            favouriteBtn.setTitle("Remove Favourite", for: .normal)
            favouriteBtn.addTarget(self, action: #selector(favouriteClicked), for: .touchUpInside)
        } else {
            favouriteBtn.setTitle("Add to Favourite", for: .normal)
            favouriteBtn.addTarget(self, action: #selector(favouriteClicked), for: .touchUpInside)
        }
    }
    
    // Base64 string to image converstion method
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    // Handle screen rotation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionview1.frame = scrollView.bounds
        scrollView1.frame = scrollView.bounds
        scrollViewDidZoom(scrollView1)
        
        collectionview2.frame = scrollView.bounds
        scrollView2.frame = scrollView.bounds
        scrollViewDidZoom(scrollView2)
    }
    
    // Create and set UI elements
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nutritional Information"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        foodName.font = .boldSystemFont(ofSize: 26)
        foodName.textAlignment = .center
        foodName.translatesAutoresizingMaskIntoConstraints = false
        
        quntityLabel.font = .systemFont(ofSize: 18)
        quntityLabel.textAlignment = .center
        quntityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let nutriInfo = UILabel()
        nutriInfo.text = "Nutrition Details"
        nutriInfo.font = .boldSystemFont(ofSize: 22)
        nutriInfo.textAlignment = .center
        nutriInfo.translatesAutoresizingMaskIntoConstraints = false
        
        collectionview1.tag = 1
        collectionview1.dataSource = self
        collectionview1.delegate = self
        collectionview1.register(TableDataCell.self, forCellWithReuseIdentifier: nutriCellID1)
        collectionview1.showsVerticalScrollIndicator = false
        collectionview1.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.addSubview(collectionview1)
        scrollView1.isPagingEnabled = true
        
        ingredInfo.text = "Ingredient Details"
        ingredInfo.font = .boldSystemFont(ofSize: 22)
        ingredInfo.textAlignment = .center
        ingredInfo.translatesAutoresizingMaskIntoConstraints = false
        
        collectionview2.tag = 2
        collectionview2.dataSource = self
        collectionview2.delegate = self
        collectionview2.register(TableDataCell.self, forCellWithReuseIdentifier: nutriCellID2)
        collectionview2.showsVerticalScrollIndicator = false
        collectionview2.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView2.translatesAutoresizingMaskIntoConstraints = false
        scrollView2.addSubview(collectionview2)
        scrollView2.isPagingEnabled = true
        
        favouriteBtn.translatesAutoresizingMaskIntoConstraints = false
        favouriteBtn.backgroundColor = .systemBlue
        favouriteBtn.layer.cornerRadius = 10
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(foodName)
        scrollView.addSubview(quntityLabel)
        scrollView.addSubview(nutriInfo)
        scrollView.addSubview(scrollView1)
        scrollView.addSubview(ingredInfo)
        scrollView.addSubview(scrollView2)
        scrollView.addSubview(favouriteBtn)
        
        view.addSubview(scrollView)
        
        // Set UI constraints and activate them
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            foodName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            foodName.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            foodName.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            quntityLabel.topAnchor.constraint(equalTo: foodName.bottomAnchor),
            quntityLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            quntityLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            nutriInfo.topAnchor.constraint(equalTo: quntityLabel.bottomAnchor, constant: 10),
            nutriInfo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            nutriInfo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            scrollView1.topAnchor.constraint(equalTo: nutriInfo.bottomAnchor, constant: 5),
            scrollView1.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            scrollView1.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            collectionview1.topAnchor.constraint(equalTo: scrollView1.topAnchor),
            collectionview1.bottomAnchor.constraint(equalTo: scrollView1.bottomAnchor),
            collectionview1.leftAnchor.constraint(equalTo: scrollView1.leftAnchor),
            collectionview1.rightAnchor.constraint(equalTo: scrollView1.rightAnchor),
            collectionview1.centerXAnchor.constraint(equalTo: scrollView1.centerXAnchor),
            
            ingredInfo.topAnchor.constraint(equalTo: collectionview1.bottomAnchor, constant: 15),
            ingredInfo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            ingredInfo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            scrollView2.topAnchor.constraint(equalTo: ingredInfo.bottomAnchor, constant: 5),
            scrollView2.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            scrollView2.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            collectionview2.topAnchor.constraint(equalTo: scrollView2.topAnchor),
            collectionview2.bottomAnchor.constraint(equalTo: scrollView2.bottomAnchor),
            collectionview2.leftAnchor.constraint(equalTo: scrollView2.leftAnchor),
            collectionview2.rightAnchor.constraint(equalTo: scrollView2.rightAnchor),
            collectionview2.centerXAnchor.constraint(equalTo: scrollView2.centerXAnchor),
            
            favouriteBtn.topAnchor.constraint(equalTo: scrollView2.bottomAnchor, constant: 20),
            favouriteBtn.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            favouriteBtn.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            favouriteBtn.heightAnchor.constraint(equalToConstant: 40),
            favouriteBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - 450) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: offsetX, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(ROW_COUNT)
    }
    
    // Set cell spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: SPACING, left: SPACING, bottom: SPACING, right: SPACING)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SPACING
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return SPACING
    }
    
    // Cell creation for 2 tables. Required table is decided using the given tag
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.tag)
        if (collectionView.tag == 2) {
            let cell = collectionview2.dequeueReusableCell(withReuseIdentifier: nutriCellID2, for: indexPath as IndexPath) as! TableDataCell
            cell.data = ingredData[indexPath.row]
            return cell
        } else {
            let cell = collectionview1.dequeueReusableCell(withReuseIdentifier: nutriCellID1, for: indexPath as IndexPath) as! TableDataCell
            cell.data = nutriData[indexPath.row]
            return cell
        }
    }
    
    // save favourite button
    @objc func favouriteClicked() {
        let username:String? = UserDefaults.standard.string(forKey: "USERNAME")
        if (username == nil) {
            let refreshAlert = UIAlertController(title: "Alert", message: "Please login to add this item to favourites", preferredStyle: .alert)
            refreshAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
        } else {
            let child = SpinnerViewController()
            addChild(child)
            child.view.frame = view.frame
            view.addSubview(child.view)
            child.didMove(toParent: self)
            if (self.foodItem!.bookMarked) {
                APICalls.removeFavourite(foodItem!.favId!, username!) { (result) in
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    if (result) {
                        self.foodItem?.bookMarked = false
                    } else {
                        let refreshAlert = UIAlertController(title: "Error", message: "Error ocurred. Please try again later.", preferredStyle: .alert)
                        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(refreshAlert, animated: true, completion: nil)
                    }
                }
            } else {
                APICalls.createFavourite(foodItem!.id, foodItem!.foodName, username!){ (result) in
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    if (result) {
                        self.reloadData()
                    } else {
                        let refreshAlert = UIAlertController(title: "Error", message: "Error ocurred. Please try again later.", preferredStyle: .alert)
                        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(refreshAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // Reload data and get new favourite id
    func reloadData() {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        let user = UserDefaults.standard.string(forKey: "USERNAME")
        if (user == nil) {
            return
        }
        APICalls.getFavourites(user!) { (favourites) in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            if (favourites == nil) {
                let alert = UIAlertController(title: "Alert", message: "Error occurred at server. Please try again later.", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            } else {
                var flag = -1
                for fav in favourites! {
                    if (fav.foodId == self.foodItem!.id) {
                        flag = fav.id
                        break
                    }
                }
                if (flag == -1) {
                    self.foodItem!.favId = nil
                    self.foodItem!.bookMarked = false
                } else {
                    self.foodItem!.favId = flag
                    self.foodItem!.bookMarked = true
                }
                self.setButtonLabel()
            }
        }
    }
    
    // Set user icon when loading again
    override func viewWillAppear(_ animated: Bool) {
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
    
}

