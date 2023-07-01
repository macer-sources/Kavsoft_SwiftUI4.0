//
//  ReceiptView.swift
//  A_09_ ImageRenderer Creating PDF
//
//  Created by Kan Tao on 2023/6/20.
//

import SwiftUI

struct ReceiptView: View {
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title.bold())
                    .foregroundColor(.green)
                
                Text("Payment Received")
                    .fontWeight(.black)
                    .foregroundColor(.green)
                
                Text("$150.690")
                    .font(.largeTitle.bold())
                
                VStack(spacing: 15) {
                    Image("avator_2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .padding(10)
                        .background {
                            Circle()
                                .fill(.white.shadow(.drop(color:.black.opacity(0.05),radius: 5)))
                        }
                    
                    Text("The Anaheim Hotel")
                        .font(.title3.bold())
                        .padding(.bottom, 12)
                    
                    LabeledContent {
                        Text("$150.690")
                            .fontWeight(.bold)
                            .foregroundColor(.black.opacity(0.6))
                    } label: {
                        Text("Total Bill")
                            .foregroundColor(.secondary)
                            .foregroundColor(.gray)
                    }

                    LabeledContent {
                        Text("$0.00")
                            .fontWeight(.bold)
                            .foregroundColor(.black.opacity(0.6))
                    } label: {
                        Text("Total Tax")
                            .foregroundColor(.secondary)
                            .foregroundColor(.gray)
                    }
                    
                    Label {
                        Text("You Got 240 Points!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("Color"))
                    } icon: {
                        Image("avator_2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color("Color").opacity(0.08))
                    }
                    .padding(.top, 5)

                    
                }
                .padding()
                .background {
                    // TODO: 设置了一个很有意思的阴影
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            .white.shadow(.drop(color: .black.opacity(0.05), radius: 10, x: 5, y: 5))
                            .shadow(.drop(color: .black.opacity(0.05), radius: 35, x: -5, y: -5))
                        )
                        .padding(.top, 35)
                }
                
                Text("Transaction Details")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack( spacing: 16) {
                    LabeledContent {
                        Text("Apple Pay")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Payment Mothod")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                    
                    LabeledContent {
                        Text("In Process")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Status")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                    
                    
                    
                    LabeledContent {
                        Text("25 Jun, 2022")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Transaction Date")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                    
                    
                    
                    LabeledContent {
                        Text("9:25 PM")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Transaction Time")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                    
                    
                    
                }
                .padding(.top)
                
            }
            .padding()
            .background {
                Color.white.ignoresSafeArea()
            }
            
            
            LabeledContent {
                Text("$150.690")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            } label: {
                Text("Total Payment")
                    .foregroundColor(.gray)
            }
            .opacity(0.7)
            .padding()
            .background {
                Color.white
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
        }
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
