//
//  ResponsiveView.swift
//  A_34_Responsive UI Design
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI

//MARK: Custom view which will give useful properties for adpotable ui
// 自定义视图，将为可采用的 UI 提供有用的属性
struct ResponsiveView<Content: View>: View {
    
    private var content:(Properties) -> Content
    init(@ViewBuilder content:@escaping (Properties) -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isLandspace = size.width >  size.height
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            
            let isMaxSplit = isSplit() && size.width < 400
            let isAdoptable = isIpad && (isLandspace ? !isMaxSplit : !isSplit())
            let properties = Properties(isLandscape: isLandspace, isiPad: isIpad, isSplit: isSplit(), isMaxSplit: isMaxSplit, isAdoptable: isAdoptable, size: size)
            
            content(properties)
                .frame(width: size.width, height: size.height)
        }
    }
}

extension ResponsiveView {
    func isSplit() -> Bool {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return false}
        return screen.windows.first?.frame.size != screen.screen.bounds.size
    }
}


struct Properties {
    var isLandscape: Bool
    var isiPad: Bool
    var isSplit: Bool
    // MARK: if the app size if reduced more than 1/3 in split mode on ipad
    // 如果在iPad上的拆分模式下应用程序大小减小超过1/3
    var isMaxSplit: Bool
    var isAdoptable: Bool
    var size: CGSize
   
}
