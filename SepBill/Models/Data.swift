//
//  Data.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import Foundation
import UIKit

enum Category: Int, Codable {
    case drinksWithoutAlcohol = 1, drinksWithAlcohol, salats, hotMeatDishes, hotFishDisches, soups, desserts, snacks, pasta
}

struct Product: Codable, Equatable, Hashable {
    let productImage: String
    let productName: String
    let productDescription: String
    let productPrice: Double
    let isSelected: Bool
    let productCategory: Category
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.productName == rhs.productName &&
               lhs.productDescription == rhs.productDescription &&
               lhs.productPrice == rhs.productPrice &&
               lhs.productCategory == rhs.productCategory &&
               lhs.productImage == rhs.productImage
    }
}
