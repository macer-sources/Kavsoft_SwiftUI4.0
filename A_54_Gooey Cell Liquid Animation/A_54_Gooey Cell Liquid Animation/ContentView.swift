//
//  ContentView.swift
//  A_54_Gooey Cell Liquid Animation
//
//  Created by Kan Tao on 2023/7/14.
//

import SwiftUI

struct ContentView: View {
    @State private var samples:[Promotion] = samples_data
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HeaderView()
                    .padding(15)
                
                ForEach(samples) { sample in
                    GooeyCell(model: sample)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
        }
    }
    
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Text("Promotions")
                .font(.system(size: 38))
                .fontWeight(.medium)
                .foregroundColor(.green)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.green)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct GooeyCell: View {
    var model: Promotion
    var onDelete:() -> Void = {}
    var body: some View {
        HStack {
            
        }
    }
}
