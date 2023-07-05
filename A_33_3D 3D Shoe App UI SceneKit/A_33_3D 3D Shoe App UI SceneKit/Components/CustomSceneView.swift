//
//  CustomSceneView.swift
//  A_33_3D 3D Shoe App UI SceneKit
//
//  Created by Kan Tao on 2023/7/4.
//

import SwiftUI
import SceneKit

struct CustomSceneView: UIViewRepresentable {
    @Binding var scene: SCNScene?
    // TODO: 由于 swiftUI 自带的无法设置background color，所以此处使用 uikit 的包装下
    func makeUIView(context: Context) -> some UIView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct CustomSceneView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
