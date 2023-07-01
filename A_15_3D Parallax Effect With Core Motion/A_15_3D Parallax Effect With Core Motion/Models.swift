//
//  Models.swift
//  A_15_3D Parallax Effect With Core Motion
//
//  Created by Kan Tao on 2023/6/21.
//

import Foundation



struct Place: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var bg: String
    var icon: String
}

var sample_datas:[Place] = [
    .init(name: "Brazil", bg: "image2", icon: ""),
    .init(name: "France", bg: "image3", icon: ""),
    .init(name: "Iceland", bg: "image4", icon: ""),
]
