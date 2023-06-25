//
//  ContentView.swift
//  A_20_Breathe App UI With Animations
//
//  Created by Kan Tao on 2023/6/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var current: BreatheType = sample_datas[0]
    
    var body: some View {
        ZStack {
            Background()
        }
    }
    
    
    // MARK: background image with gradient overlays
    @ViewBuilder
    func Background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            Image("pexels_1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [current.color.opacity(0.9), .clear, .clear], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height / 1.5)
                            .frame(maxHeight: .infinity, alignment: .top)
                        
                        
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .clear,
                                .black,
                                .black,
                                .black,
                                .black
                            ], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height / 1.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
        }
        .ignoresSafeArea()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
