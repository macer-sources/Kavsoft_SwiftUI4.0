//
//  Extensions.swift
//  A_16_Dynamic Animated Tab Indicator
//
//  Created by Kan Tao on 2023/6/21.
//

import Foundation
import SwiftUI

extension View {
    
    @ViewBuilder
    func offsetX(completion:@escaping(CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let minX = proxy.frame(in: .global).minX
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
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
