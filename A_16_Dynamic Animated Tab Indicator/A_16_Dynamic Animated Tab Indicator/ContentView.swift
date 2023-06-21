//
//  ContentView.swift
//  A_16_Dynamic Animated Tab Indicator
//
//  Created by Kan Tao on 2023/6/21.
//

import SwiftUI

struct ContentView: View {
    @State var current: Tab = sample_datas.first!
    var body: some View {
        ZStack {
            TabView(selection: $current) {
                ForEach(sample_datas, id: \.id) { tab in
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        Image(tab.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipped()
                    }
                    .ignoresSafeArea()
                }
            }
            .ignoresSafeArea()
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
