//
//  Expense.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/6/23.
//

import SwiftUI

enum ExpenseType: String {
    case income = "Income"
    case expense = "expenses"
    case all = "all"
}

struct Expense: Identifiable, Hashable {
    var id = UUID().uuidString
    var remark: String
    var amount: Double
    var date: Date
    var type: ExpenseType
    var color: Color
}


var sample_expenses:[Expense] = [
    .init(remark: "Magic Keyboard", amount: 99, date: Date(timeIntervalSince1970: 1652987245), type: .expense, color: .yellow),
    .init(remark: "Food", amount: 19, date: Date.init(timeIntervalSince1970: 1652977245), type: .expense, color: .red),
    .init(remark: "Magic Trackpad", amount: 99, date: Date.init(timeIntervalSince1970: 1652974245), type: .income, color: .green),
    .init(remark: "Uber Cab", amount: 20, date: Date.init(timeIntervalSince1970: 1652877245), type: .expense, color: .yellow),
    .init(remark: "Amazon Purchase", amount: 299, date: Date.init(timeIntervalSince1970: 1652966245), type: .income, color: .green),
    .init(remark: "Stocks", amount: 300, date: Date.init(timeIntervalSince1970: 1652957245), type: .income, color: .purple),
]
