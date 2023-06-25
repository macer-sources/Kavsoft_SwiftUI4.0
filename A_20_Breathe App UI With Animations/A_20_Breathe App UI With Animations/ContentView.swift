//
//  ContentView.swift
//  A_20_Breathe App UI With Animations
//
//  Created by Kan Tao on 2023/6/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var current: BreatheType = sample_datas[0]
    @Namespace var animation
    
    var body: some View {
        ZStack {
            Background()
            
            Content()
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
    
    
    @ViewBuilder
    func Content() -> some View {
        VStack {
            HStack {
                Text("Breathe")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    
                } label: {
                    Image(systemName: "suit.heart")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial)
                        }
                }

            }
            .padding()
            
            GeometryReader { proxy in
                let size = proxy.size
                
                VStack {
                    BreatheView(size: size)
                    
                    Text("Breathe to reduce")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sample_datas) { type in
                                Text(type.title)
                                    .foregroundColor(current.id == type.id ?.black :.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background {
                                        ZStack {
                                            if current.id == type.id {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.white)
                                                    .matchedGeometryEffect(id: "TAB", in: animation)
                                            }else {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.white.opacity(0.5))
                                            }
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            current = type
                                        }
                                    }
                            }
                        }
                        .padding()
                        .padding(.leading, 25)
                    }
                    
                    Button {
                        
                    } label: {
                        Text("START")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(current.color.gradient)
                            }
                    }
                    .padding()

                }
                .frame(width: size.width, height: size.height, alignment: .bottom)
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    
    
    @ViewBuilder
    func BreatheView(size: CGSize) -> some View  {
        // MARK: 动画 使用 8 个圆，
        ZStack {
            ForEach(1...8,id: \.self) { index in
                Circle()
                    .fill(current.color.gradient.opacity(0.5))
                    .frame(width: 150, height: 150)
                    // 150 / 2
                    .offset(x: 75)
                    // 45 * 8 = 360
                    .rotationEffect(.init(degrees: Double(index) * 45))
            }
        }
        .frame(height: size.width - 40)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
