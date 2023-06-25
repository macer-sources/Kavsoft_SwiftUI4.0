//
//  Models.swift
//  A_20_Breathe App UI With Animations
//
//  Created by Kan Tao on 2023/6/25.
//

import SwiftUI


struct BreatheType: Identifiable, Hashable {
    var id = UUID().uuidString
    var title: String
    var color: Color
}


let sample_datas:[BreatheType] = [
    .init(title: "Anger", color: .mint),
    .init(title: "Irritation", color: .brown),
    .init(title: "Sadness", color: Color("purple"))
]
