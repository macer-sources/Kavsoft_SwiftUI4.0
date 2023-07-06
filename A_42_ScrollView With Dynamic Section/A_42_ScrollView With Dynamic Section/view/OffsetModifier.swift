//
//  OffsetModifier.swift
//  A_42_ScrollView With Dynamic Section
//
//  Created by Kan Tao on 2023/7/6.
//

import SwiftUI

extension View {
    @ViewBuilder
    func offset(completion:@escaping (CGRect) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named("SCROLLER"))
                Color.clear
                    .preference(key: OffsetKey.self,value: rect)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}


struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
