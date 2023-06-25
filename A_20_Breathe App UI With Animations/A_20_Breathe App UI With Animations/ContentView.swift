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
    
    // MARK: Animation properties
    @State var showBreatheView:Bool = false
    @State var startAnimation: Bool = false
    
    // MARK: Timer properties
    @State var timerCount:CGFloat = 0
    @State var breatheAction: String = "Breathe In"
    @State var count: Int = 0
    
    var body: some View {
        ZStack {
            Background()
            
            Content()
            
            Text(breatheAction)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 50)
                .opacity(showBreatheView ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: breatheAction)
                .animation(.easeInOut(duration: 1), value: showBreatheView)
            
        }
        // MARK: Timer
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if showBreatheView {
                if timerCount >= 3.2 {
                    timerCount = 0
                    breatheAction = (breatheAction == "Breathe Out" ? "Breathe In" : "Breathe Out")
                    withAnimation(.easeInOut(duration: 3).delay(0.1)) {
                        startAnimation.toggle()
                    }
                    // MARK: 触觉反馈
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    
                }else {
                    timerCount += 0.01
                }
                
                count = 3 - Int(timerCount)
            }else {
                // resetting
                timerCount = 0
            }
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
                .blur(radius: startAnimation ? 4 : 0, opaque: true)
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
            .opacity(showBreatheView ? 0 : 1)
            
            GeometryReader { proxy in
                let size = proxy.size
                
                VStack {
                    BreatheView(size: size)
                    
                    Text("Breathe to reduce")
                        .font(.title3)
                        .foregroundColor(.white)
                        .opacity(showBreatheView ? 0 : 1)
                    
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
                    .opacity(showBreatheView ? 0 : 1)
                    
                    Button {
                        startBreathing()
                    } label: {
                        Text(showBreatheView ? "Finish Breathing" :"START")
                            .fontWeight(.semibold)
                            .foregroundColor(showBreatheView ? .white.opacity(0.75) : .black)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                if showBreatheView {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white.opacity(0.5))
                                }else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(current.color.gradient)
                                }
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
                    .offset(x: startAnimation ? 0 : 75)
                    // 45 * 8 = 360
                    .rotationEffect(.init(degrees: Double(index) * 45))
                    .rotationEffect(.init(degrees: startAnimation ? -45 : 0))
            }
        }
        .scaleEffect(startAnimation ? 0.8 : 1)
        .overlay(content: {
            Text("\(count == 0 ? 1 : count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .animation(.easeInOut, value: count)
                .opacity(showBreatheView ? 1 : 0)
        })
        .frame(height: size.width - 40)
        
    }
    
    
    // MARK: Breathing action
    func startBreathing() {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
            showBreatheView.toggle()
        }
        if showBreatheView {
            withAnimation(.easeInOut(duration: 3).delay(0.05)) {
                startAnimation = true
            }
        }else {
            withAnimation(.easeInOut(duration: 1.5)) {
                startAnimation = false
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
