//
//  ContentView.swift
//  A_09_ ImageRenderer Creating PDF
//
//  Created by Kan Tao on 2023/6/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                
                ReceiptView()
                
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }

                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.up.doc")
                            .font(.title3)
                    }

                }
                .foregroundColor(.gray)
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
