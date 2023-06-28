//
//  CustomColorFinderView.swift
//  A_26_Lock Screen Depth Effect
//
//  Created by Kan Tao on 2023/6/28.
//

import SwiftUI

// MARK: This view will return color based on the xy coordinates
struct CustomColorFinderView<Content: View>: UIViewRepresentable {
    @EnvironmentObject var viewModel: LockScreenViewModel
    
    var content: Content
    var onLoad:(UIView) ->  Void
    
    
    init(@ViewBuilder content: @escaping () -> Content, onLoad: @escaping (UIView) -> Void) {
        self.content = content()
        self.onLoad = onLoad
    }
    
    func makeUIView(context: Context) -> some UIView {
        let size = UIApplication.shared.screenSize()
        let host = UIHostingController(rootView: content
            .frame(width: size.width, height: size.height)
            .environmentObject(viewModel)
        )
        host.view.frame = CGRect.init(origin: .zero, size: size)
        
        return host.view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // simply getting the uiview as reference so that we can check color of the view
        DispatchQueue.main.async {
            onLoad(uiView)
        }
    }
}

