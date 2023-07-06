//
//  Character.swift
//  A_42_ScrollView With Dynamic Section
//
//  Created by Kan Tao on 2023/7/6.
//

import SwiftUI




// MARK: Character Model For Holding Data about Each Alphabet
struct Character: Identifiable {
    var id = UUID().uuidString
    var value: String
    var index: Int = 0
    var rect: CGRect = .zero
    var pushOffset: CGFloat = 0
    var isCurrent: Bool = false
    var color: Color = .clear
}
