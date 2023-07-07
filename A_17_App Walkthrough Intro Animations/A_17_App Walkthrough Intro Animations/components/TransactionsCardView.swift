//
//  TransactionsCardView.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/6/23.
//

import SwiftUI

struct TransactionsCardView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    var expense:Expense
    var body: some View {
        HStack(spacing: 12) {
            if let first = expense.remark.first {
                Text(String(first))
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: 50,height: 50)
                    .background {
                        Circle()
                            .fill(expense.color)
                    }
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
            }
            
            Text(expense.remark)
                .fontWeight(.semibold)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing,spacing: 7) {
                // MARK: Displaying Price
                let price = viewModel.convertNumberToPrice(value: expense.type == .expense ? -expense.amount : expense.amount)
                Text(price)
                    .font(.callout)
                    .opacity(0.7)
                    .foregroundColor(expense.type == .expense ? .red : .green)
                Text(expense.date.formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .opacity(0.5)
                    
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
        }
    }
}

struct TransactionsCardView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
