//
//  ContentView.swift
//  A_27_Grid Magnification Effect
//
//  Created by Kan Tao on 2023/7/3.
//

import SwiftUI

struct ContentView: View {
    
    @GestureState var location: CGPoint = .zero
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            // MARK: 为了适应整个视图，在高度和宽度的帮助下计算项目计数
            let width = (size.width / 10) // item width
            // Multiplying each row count
            let itemCount = Int((size.height / width).rounded()) * 10
            
            LinearGradient(colors: [
                .cyan,
                .yellow,
                .mint,
                .pink,
                .purple
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .mask {
                // TODO: 10 列
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 10), spacing: 0) {
                    ForEach(0..<itemCount,id: \.self) { _ in
                        GeometryReader { innerProxy in
                            let rect = innerProxy.frame(in: .named("GESTURE"))
                            let scale = itemScale(rect: rect, size: size)
                            
                            
                            // MARK: Instead of manual calculation
                            // 通过使用 CGAffineTransform 实现3d⚽️效果，
                            let transformedRect = rect.applying(.init(scaleX: scale, y: scale))
                            
                            let transformedLocation = location.applying(.init(scaleX: scale, y: scale))
                            
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.orange)
//                                .scaleEffect(scale)
                            // MARK: For Effect 1
                            // 我们需要将每个项目重新定位到当前 draaging 的位置
                                .offset(x: (transformedRect.minX - rect.minX), y: (transformedRect.minY - rect.minY))
                                .offset(x: location.x - transformedLocation.x, y: location.y - transformedLocation.y)
                            // MARK: effect 2 实现，调整scaleEffect位置
                                .scaleEffect(scale)
                        }
                        .padding(5)
                        .frame(height: width)
                    }
                }
            }
        }
        .padding(15)
        .gesture(DragGesture(minimumDistance: 0 ).updating($location, body: { value, out, _ in
            out = value.location
        }))
        .coordinateSpace(name: "GESTURE")
        .preferredColorScheme(.dark)
        .animation(.easeInOut, value: location == .zero)
    }
}

extension ContentView {
    // MARK: Calculating scale for each item with the help of pythagorean theorem(借助勾股定理计算每个item的尺度)
    func itemScale(rect: CGRect, size: CGSize) -> CGFloat {
        let a = location.x - rect.minX
        let b = location.y - rect.minY
        
        let root = sqrt((a * a) + (b * b))
        let diagonalValue = sqrt((size.width * size.width) + (size.height * size.height))
        
        // MARK: 有关更多详细信息，查看
        let scale = root / (diagonalValue / 2)
        let modifiedScale = location == .zero ?  1 : (1 - scale)
        
        // MARK: 避免快速转换警告
        return modifiedScale >  0 ? modifiedScale : 0.001
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
