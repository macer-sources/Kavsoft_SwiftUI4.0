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
            VStack(spacing: 12) {
                HeaderView()
                    .padding(15)
                
                ForEach(samples) { sample in
                    GooeyCell(model: sample)
                }
            }
            .padding(.vertical, 18)
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
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(model.logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text(model.name)
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                
                Text(model.title)
                    .foregroundColor(.black.opacity(0.8))
                
                Text(model.subTitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .lineLimit(1)
            
            Spacer()
            
            Text("29 OTC")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.green.opacity(0.7))
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white.opacity(0.7))
        }
        .padding(.horizontal, 15)
    }
}
