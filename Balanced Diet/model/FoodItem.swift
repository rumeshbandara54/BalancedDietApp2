//
//  FoodItem.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import Foundation

// Fooditem related objects
struct FoodItemDTO: Codable {
    var id: Int
    var foodCategoryId: Int
    var foodName: String
    var foodImage: String
    var quantity: Int
    var foodNutritions: [Nutritions]
    var foodIngrediants: [Ingrediants]
}

struct FoodItem: Codable {
    var id: Int
    var foodCategoryId: Int
    var foodName: String
    var foodImage: String
    var quantity: Int
    var bookMarked = false
    var favId: Int?
    var foodNutritions: [Nutritions]
    var foodIngrediants: [Ingrediants]
}

struct Nutritions: Codable {
    var id: Int
    var foodId: Int
    var nutritionId: Int
    var nutritionName: String
    var servingAmount: Float
    var nutritionAmount: Float
}

struct Ingrediants: Codable {
    var id: Int
    var foodId: Int
    var ingrediantId: Int
    var ingrediantName: String
    var servingAmount: Float
    var caloryAmount: Float
}
