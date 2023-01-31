//
//  APICalls.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import Foundation

class APICalls: ObservableObject {
    
    // This class handle all API calls
    
    static let BASE_URL = "https://fdms1api.azurewebsites.net/api/"
    
    // Get food items depending on selected type
    static func getFoodItems(_ type: Int, completion:@escaping ([FoodItemDTO]?) -> ()) {
        let url: URL
        switch (type)  {
          case 0:
            url = URL(string: (BASE_URL + "Food/GetFatsFoods"))!
          case 1:
            url = URL(string: (BASE_URL + "Food/GetMeatFoods"))!
          case 2:
            url = URL(string: (BASE_URL + "Food/GetMilkFoods"))!
          case 3:
            url = URL(string: (BASE_URL + "Food/GetVegetableFoods"))!
          case 4:
            url = URL(string: (BASE_URL + "Food/GetFruitsFoods"))!
          case 5:
            url = URL(string: (BASE_URL + "Food/GetBakeryFoods"))!
          default:
            url = URL(string: (BASE_URL + "Food/GetFoods"))!
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let foodItems:[FoodItemDTO]?;
            if (data != nil) {
                foodItems = try? JSONDecoder().decode([FoodItemDTO].self, from: data!)
            } else {
                foodItems = nil
            }
            DispatchQueue.main.async {
                completion(foodItems)
            }
        }.resume()
        
    }
    
    // Call register method as POST
    static func registerUser(_ username: String, _ email: String, _ password: String, completion:@escaping (Bool) -> ()) {
        let data: [String: String?] = ["userName": username, "email": email, "password": password, "address": ""]
        
        let url = URL(string: (BASE_URL + "User/RegisterUser"))!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: data)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if (data != nil) {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
        
    }
    
    // Login method
    static func loginUser(_ username: String, _ password: String, completion:@escaping (Bool) -> ()) {
        let url = URL(string: (BASE_URL + "User/Login?userName=\(username)&password=\(password)"))!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if (data != nil && data?.count == 4) {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
        
    }
    
    // Get favourites for user
    static func getFavourites(_ username: String, completion:@escaping ([FavouriteDTO]?) -> ()) {
        let url = URL(string: (BASE_URL + "Favorite/GetAllFavoritesByUserId?userId=\(1)"))!
        URLSession.shared.dataTask(with: url) { data, response, error in
            let favouriteItems:[FavouriteDTO]?;
            if (data != nil) {
                favouriteItems = try? JSONDecoder().decode([FavouriteDTO].self, from: data!)
            } else {
                favouriteItems = nil
            }
            DispatchQueue.main.async {
                completion(favouriteItems)
            }
        }.resume()
        
    }
    
    // Add item as favourite
    static func createFavourite(_ foodId: Int, _ foodName: String, _ username: String, completion:@escaping (Bool) -> ()) {
        let data: [String: Any?] = ["foodId": foodId, "favoriteName": foodName, "userId": 1]
        
        let url = URL(string: (BASE_URL + "Favorite/CreateFavorites"))!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: data)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if (error == nil) {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
        
    }
    
    // Remove item as favourite
    static func removeFavourite(_ favId: Int, _ username: String, completion:@escaping (Bool) -> ()) {
        let url = URL(string: (BASE_URL + "Favorite/RemoveFavorites?userId=1&favoriteId=\(favId)"))!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            DispatchQueue.main.async {
                completion((httpResponse?.statusCode != nil && httpResponse!.statusCode == 200))
            }
        }.resume()
        
    }
    
}
