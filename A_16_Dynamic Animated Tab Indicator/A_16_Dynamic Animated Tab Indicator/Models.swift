//
//  Models.swift
//  A_16_Dynamic Animated Tab Indicator
//
//  Created by Kan Tao on 2023/6/21.
//

import Foundation


struct Tab: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var image: String
}


var sample_datas:[Tab] = [
    .init(name: "Iceland", image: "image1"),
    .init(name: "France", image: "image2"),
    .init(name: "Brazil", image: "image3")
]
