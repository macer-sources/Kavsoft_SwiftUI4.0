//
//  Intro.swift
//  A_49_Walkthrough Page Animation
//
//  Created by Kan Tao on 2023/7/10.
//

import SwiftUI

struct Intro: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
}


var sample_datas:[Intro] = [
    .init(image: "Image 1", title: "Relax"),
    .init(image: "Image 1", title: "Care"),
    .init(image: "Image 1", title: "Mood Dairy"),
]

