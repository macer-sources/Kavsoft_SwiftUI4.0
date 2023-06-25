//
//  ScratchCardView.swift
//  A_19_Matched Geometry Effect Masking
//
//  Created by Kan Tao on 2023/6/25.
//

import SwiftUI

// MARK: Custom View
struct ScratchCardView<Content: View, Overlay: View>: View {
    var content: Content
    var overlay: Overlay
    
    // 点的大小
    var pointSize: CGFloat
    var onFinish: () -> Void
    
    init(pointSize: CGFloat, @ViewBuilder content: @escaping () -> Content,@ViewBuilder overlay: @escaping () -> Overlay,  onFinish: @escaping () -> Void) {
        self.content = content()
        self.overlay = overlay()
        self.pointSize = pointSize
        self.onFinish = onFinish
    }
    
    
    @State var dragPoints:[CGPoint] = []
    @State var animateCard: [Bool] = [false, false]
    
    var body: some View {
        // 逻辑很简单
        // 我们根据拖动位置一点一点 mask 内容和遮罩
        ZStack {
            overlay
            
            content
                .mask {
                    PointShape(points: dragPoints)
                    //使用 stroke 以便它为每个点应用圆
                        .stroke(style: StrokeStyle.init(lineWidth: pointSize, lineCap: .round, lineJoin: .round))
                }
                .gesture(
                    DragGesture().onChanged({ value in
                        // MARK: adding points
                        dragPoints.append(value.location)
                    })
                )
        }
        // TODO: 添加浮动动画效果
        .rotation3DEffect(.init(degrees: animateCard[0] ? 4: 0), axis: (x: 1, y: 0, z: 0))
        .rotation3DEffect(.init(degrees: animateCard[1] ? 4: 0), axis: (x: 0, y: 1, z: 0))
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animateCard[0] = true
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.8)) {
                animateCard[1] = true
            }
        }
    }
}

struct ScratchCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: Custom Path Shape based on drag locations
struct PointShape: Shape {
    var points:[CGPoint]
    
    // MARK: since we need animation
    var animatableData: [CGPoint] {
        get {points}
        set {points = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            if let first = points.first {
                path.move(to: first)
                path.addLines(points)
            }
        }
    }
}
