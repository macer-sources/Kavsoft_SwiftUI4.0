//
//  Extensions.swift
//  A_18_Hides On Swipe Animated Header
//
//  Created by Kan Tao on 2023/6/21.
//

import Foundation
import SwiftUI

// MARK: Custom view extensions

extension View {
    // MARK: Previos, current offset to find the direction of swipe
    @ViewBuilder
    func offsetY(completion:@escaping(CGFloat,CGFloat) -> Void) -> some View {
        self
            .modifier(OffsetHelper(onChange: completion))
    }
    
    
    func safeArea() -> UIEdgeInsets {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return .zero}
        guard let safeArea = scene.windows.first?.safeAreaInsets else {return .zero}
        return safeArea
    }
}


// MARK: offset helper

struct OffsetHelper: ViewModifier {
    var onChange:(CGFloat, CGFloat) -> Void
    @State var current: CGFloat = 0
    @State var previous: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            previous = current
                            current = value
                            onChange(previous, current)
                        }
                }
            }
    }
}



struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: bounds preference key for identiying height of the header view
struct HeaderBoundsKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>?
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}
