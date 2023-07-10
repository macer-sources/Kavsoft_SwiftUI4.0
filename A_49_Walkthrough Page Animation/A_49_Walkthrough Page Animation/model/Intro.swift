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
    .init(image: "image1", title: "Relax"),
    .init(image: "image2", title: "Care"),
    .init(image: "image3", title: "Mood Dairy"),
]

let dummpText = "In this Video I'm going to teach how to create Stylish App Intro Animation's  Using SwiftUI 4.0"
