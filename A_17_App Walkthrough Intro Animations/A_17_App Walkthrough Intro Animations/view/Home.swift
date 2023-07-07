//
//  Home.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/6/23.
//

import SwiftUI

struct Home: View {
    @StateObject var viewModel = ExpenseViewModel()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                HStack(spacing: 15) {
                    VStack(alignment: .leading,spacing: 4) {
                        Text("Welcome")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("iJustine")
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "hexagon.fill")
                            .foregroundColor(.gray)
                            .overlay(content: {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .padding(7)
                            })
                            .frame(width: 40, height: 40)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }

                }
                
                ExpenseCardView()
                TransactionsView()
            }
            .padding()
        }
        .ignoresSafeArea(.all,edges: [])
        .background {
            Color("bg")
                .ignoresSafeArea()
        }
    }
}


// MARK: Transactions View
extension Home {
    @ViewBuilder
    func TransactionsView() -> some View {
        VStack(spacing: 15) {
            Text("Transactions")
                .font(.title2.bold())
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            ForEach(sample_expenses) { expense in
                // MARK: Transactions Card Item
                TransactionsCardView(expense: expense).environmentObject(viewModel)
            }
        }
    }
}

// MARK: Expense Gradient Cardview
extension Home {
    @ViewBuilder
    func ExpenseCardView() -> some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    .linearGradient(colors: [
                        Color("gradient1"),
                        Color("gradient2"),
                        Color("gradient3")
                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing)
                )
            
            
            VStack(spacing: 15) {
                VStack(spacing: 15) {
                    // MARK: Currently going month date string
                    Text(viewModel.currentMonthDateString())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    // MARK: Current Month Expenses Price
                    Text(viewModel.convertExpensesToCurrency(expenses: viewModel.expenses))
                        .font(.system(size: 35, weight: .bold))
                        .lineLimit(1)
                        .padding(.bottom, 5)
                }
                .offset(y: -10)
                
                HStack(spacing: 15) {
                    Image(systemName: "arrow.down")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .frame(width: 30, height: 30)
                        .background {
                            Circle()
                                .fill(.white.opacity(0.7))
                        }
                    
                    VStack(alignment: .leading,spacing: 4) {
                        Text("Income")
                            .font(.caption)
                            .opacity(0.7)
                        
                        Text(viewModel.convertExpensesToCurrency(expenses: viewModel.expenses, type: .income))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Image(systemName: "arrow.up")
                        .font(.caption.bold())
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                        .background {
                            Circle()
                                .fill(.white.opacity(0.7))
                        }
                    
                    VStack(alignment: .leading,spacing: 4) {
                        Text("Expenses")
                            .font(.caption)
                            .opacity(0.7)
                        
                        Text(viewModel.convertExpensesToCurrency(expenses: viewModel.expenses, type: .income))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }
                .padding(.horizontal)
                .padding(.trailing)
                .offset(y: 15)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            
            
        }
        .frame(height: 220)
        .padding(.top)
    }
}






struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
