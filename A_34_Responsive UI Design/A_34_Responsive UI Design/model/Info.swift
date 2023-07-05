//
//  Info.swift
//  A_34_Responsive UI Design
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI

struct Info: Identifiable {
    var id = UUID().uuidString
    var title: String
    var amount: String
    var percentage: Int
    var loss: Bool = false
    var icon: String
    var iconColor: Color
}

var sample_infos:[Info] = [
    .init(title: "Revenus", amount: "$2.047", percentage: 10,loss: true, icon: "arrow.up.right", iconColor: .orange),
    .init(title: "Orders", amount: "356", percentage: 20, icon: "cart", iconColor: .green),
    .init(title: "Dine in", amount: "220", percentage: 10,icon: "fork.knife", iconColor: .red),
    .init(title: "Take away", amount: "135", percentage: 5,loss: true, icon: "takeoutbag.and.cup.and.straw.fill", iconColor: .yellow)
]
