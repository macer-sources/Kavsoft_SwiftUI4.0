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
    
    
    var body: some View {
        // 逻辑很简单
        // 我们根据拖动位置一点一点 mask 内容和遮罩
        ZStack {
            overlay
            
            content
                .mask {
                    
                }
        }
    }
}

struct ScratchCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
