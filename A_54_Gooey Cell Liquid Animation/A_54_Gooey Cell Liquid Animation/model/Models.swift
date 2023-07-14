//
//  Models.swift
//  A_54_Gooey Cell Liquid Animation
//
//  Created by Kan Tao on 2023/7/14.
//

import Foundation


struct Promotion: Identifiable {
    var id = UUID().uuidString
    var name: String
    var title: String
    var subTitle: String
    var logo: String
}

var samples_data:[Promotion] = [
    .init(name: "TripAdvisor", title: "Your saved search to Vienna", subTitle: "In this video, I'll demonstrate", logo: "avator_1"),
    .init(name: "Figma", title: "Figma mentions are here!", subTitle: "how to use SwiftUI to create a nice Gooey", logo: "avator_2"),
]
