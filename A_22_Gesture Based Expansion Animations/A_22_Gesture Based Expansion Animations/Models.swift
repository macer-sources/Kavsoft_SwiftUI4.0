//
//  Models.swift
//  A_22_Gesture Based Expansion Animations
//
//  Created by Kan Tao on 2023/6/26.
//

import SwiftUI

struct Tool: Identifiable {
    var id = UUID().uuidString
    var icon: String
    var name: String
    var color: Color
    var toolPostion: CGRect = .zero
}

