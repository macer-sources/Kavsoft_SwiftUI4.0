//
//  Models.swift
//  A_24_Animated Carousel
//
//  Created by Kan Tao on 2023/6/27.
//

import SwiftUI

struct Movie: Identifiable, Equatable {
    var id = UUID().uuidString
    var name: String
    var artwork: String
}

var sample_datas:[Movie] = [
    .init(name: "Ad Astra", artwork: "pexels_1"),
    .init(name: "SwiftUI Custom ", artwork: "pexels_2"),
    .init(name: "Animated Tab Bar", artwork: "pexels_3"),
    .init(name: "SwiftUI Complex Animations", artwork: "pexels_4"),
    .init(name: "SwiftUI Snap Carousel", artwork: "pexels_5"),
    .init(name: "SwiftUI Animated Carousel", artwork: "pexels_6")
]




enum Tab: String, CaseIterable {
    case home = "Home"
    case explore = "Explore"
    case heart  = "Heart"
    case profile = "Profile"
}
