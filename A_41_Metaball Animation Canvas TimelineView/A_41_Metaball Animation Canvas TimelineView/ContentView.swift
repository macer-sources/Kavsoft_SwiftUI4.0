//
//  ContentView.swift
//  A_41_Metaball Animation Canvas TimelineView
//
//  Created by Kan Tao on 2023/7/6.
//

import SwiftUI

struct ContentView: View {
    // MARK: Animation properties
    @State var dragOffset: CGSize = .zero
    
    
    var body: some View {
        VStack {
            SingleMetaBall()
        }
        .preferredColorScheme(.dark)
    }
}



extension ContentView {
    @ViewBuilder
    func SingleMetaBall() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [
                .red,
                .orange,
                .yellow,
            ], startPoint: .top, endPoint: .bottom))
            .mask {
                
                Canvas { context , size  in
                    // change here if you need custom color
                    // TODO: 这里才是决定最终颜色的地方，和 Ball 内部设置颜色无关
                    context.addFilter(.alphaThreshold(min: 0.5 , color: .yellow))
                    context.addFilter(.blur(radius: 30))
                    
                    context.drawLayer { ctx in
                        // MARK: Placing Symbols
                        for index in [1, 2] {
                            if let resolvedView = context.resolveSymbol(id: index) {
                                ctx.draw(resolvedView, at: CGPoint.init(x: size.width / 2, y: size.height / 2))
                            }
                        }
                    }
                    
                }symbols: {
                    Ball()
                        .tag(1)
                    Ball(offset: dragOffset)
                        .tag(2)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged({ value  in
                        dragOffset = value.translation
                    })
                    .onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            dragOffset = .zero
                        }
                    })
            )
    }
    
    
    @ViewBuilder
    func Ball(offset: CGSize = .zero) -> some View {
        Circle()
            .fill(.red)
            .frame(width: 150, height: 150)
            .offset(offset)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
