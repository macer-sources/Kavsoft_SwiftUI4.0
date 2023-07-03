//
//  ContentView.swift
//  A_27_Grid Magnification Effect
//
//  Created by Kan Tao on 2023/7/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            // MARK: 为了适应整个视图，在高度和宽度的帮助下计算项目计数
            let width = (size.width / 10) // item width
            // Multiplying each row count
            let itemCount = Int((size.height / width).rounded()) * 10
            
            // TODO: 10 列
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 10), spacing: 0) {
                ForEach(0..<itemCount,id: \.self) { _ in
                    GeometryReader { innerProxy in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.orange)
                    }
                    .padding(5)
                    .frame(height: width)
                }
            }
            
        }
        .padding(15)
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
