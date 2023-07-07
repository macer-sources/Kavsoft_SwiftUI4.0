//
//  ExpenseViewModel.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/6/23.
//

import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses:[Expense] = sample_expenses
    
    
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    @Published var currentMonthStartDate: Date = .now
    
    init() {
        // MARK: Fetching current month starting date
        let calender = Calendar.current
        
        let components = calender.dateComponents([.year, .month], from: Date())
        startDate = calender.date(from: components)!
        currentMonthStartDate = calender.date(from: components)!
    }
}


extension ExpenseViewModel {
    // MARK: Fetching current month date string
    func currentMonthDateString() -> String {
        return currentMonthStartDate.formatted(date: .abbreviated, time: .omitted) + "-" + Date().formatted(date: .abbreviated, time: .omitted)
    }
}


extension ExpenseViewModel {
    func convertExpensesToCurrency(expenses:[Expense], type: ExpenseType = .all) -> String {
        var value: Double = 0
        value = expenses.reduce(0, { partialResult, expense in
            return partialResult + (expense.type == .income ? expense.amount : -expense.amount)
        })
        
       return convertNumberToPrice(value: value)
    }
}


extension ExpenseViewModel {
    // MARK: Converting number to price
    func convertNumberToPrice(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: value)) ?? "$0.00"
    }
}
