//
//  FavouriteDTO.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import Foundation

// used parse data sent from backend
struct FavouriteDTO: Codable {
    var id: Int
    var foodId: Int
    var favoriteName: String
    var userId: Int
}
