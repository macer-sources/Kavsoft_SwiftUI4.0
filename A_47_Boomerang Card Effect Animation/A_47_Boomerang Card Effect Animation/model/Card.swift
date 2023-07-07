//
//  Card.swift
//  A_47_Boomerang Card Effect Animation
//
//  Created by Kan Tao on 2023/7/7.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID().uuidString
    var image: String
    var isRotated: Bool = false
    var extraOffset: CGFloat = 0
    var scale: CGFloat = 1
    var zIndex: Double = 0
}
