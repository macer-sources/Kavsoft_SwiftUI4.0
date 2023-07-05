//
//  Trending.swift
//  A_34_Responsive UI Design
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI

struct Trending: Identifiable {
    var id = UUID().uuidString
    var title: String
    var subTitle: String
    var count: Int
    var image: String
}


var sample_trendings:[Trending] = [
    .init(title: "American Favourite", subTitle: "Order", count: 120, image: "Pizzal"),
    .init(title: "Super Supreme", subTitle: "Order", count: 90, image: "Pizza2"),
    .init(title: "Orange Juice", subTitle: "Order", count: 110, image: "Pizza3"),
    .init(title: "Chicken Mushroom", subTitle: "Order", count: 70, image: "OrangeJuice")
]
