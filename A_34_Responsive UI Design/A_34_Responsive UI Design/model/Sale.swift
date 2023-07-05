//
//  Sale.swift
//  A_34_Responsive UI Design
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI

struct Sale: Identifiable {
    var id: String = UUID().uuidString
    var sales:Int
    var time: String
}

var sample_sales:[Sale] = [
    .init(sales: 20, time: "11:00"),
    .init(sales: 40, time: "12:00"),
    .init(sales: 40, time: "1:00"),
    .init(sales: 150, time: "2:00"),
    .init(sales: 260, time: "3:00"),
    .init(sales: 80, time: "4:00"),
    .init(sales: 120, time: "5:00"),
    .init(sales: 50, time: "6:00"),
    .init(sales: 30, time: "7:00"),
]
