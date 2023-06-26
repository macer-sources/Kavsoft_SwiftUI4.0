//
//  ContentView.swift
//  A_22_Gesture Based Expansion Animations
//
//  Created by Kan Tao on 2023/6/26.
//

import SwiftUI

struct ContentView: View {
    @State var tools:[Tool] = [
        .init(icon: "scribble.variable", name: "Scribble", color: .purple),
        .init(icon: "lasso", name: "Lasso", color: .green),
        .init(icon: "plus.bubble", name: "Comment", color: .blue),
        .init(icon: "bubbles.and.sparkles.fill", name: "Enhance", color: .orange),
        .init(icon: "paintbrush.pointed.fill", name: "Picker", color: .pink),
        .init(icon: "rotate.3d", name: "Rotate", color: .indigo),
        .init(icon: "gear.badge.questionmark", name: "Settings", color: .yellow)
    ]
    
    
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
               Tool()
            }
            .navigationTitle("Tool Animation")
        }
    }
}

extension ContentView {
    @ViewBuilder
    func Tool() -> some View {
        VStack {
            
            VStack(alignment: .leading,spacing: 12 ) {
                ForEach($tools) { $tool in
                    ToolView(tool: tool)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        .white.shadow(
                            .drop(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                        )
                        .shadow(.drop(color: .black.opacity(0.05), radius: 5, x: -5, y: -5))
                    )
                // MARK: 控制背景大小，避免将文字也包含进来
                // image size = 45， padding = 20
                // total = 65
                    .frame(width: 65)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    func ToolView(tool: Tool) -> some View {
        HStack(spacing: 5) {
            Image(systemName: tool.icon)
                .font(.title2)
                .frame(width: 45, height: 45)
            
            Text(tool.name)
                .padding(.trailing, 15)
                .foregroundColor(.white)
            
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(tool.color.gradient)
        }
    }
    
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
