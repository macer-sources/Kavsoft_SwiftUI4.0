//
//  IntroView.swift
//  A_49_Walkthrough Page Animation
//
//  Created by Kan Tao on 2023/7/10.
//

import SwiftUI

struct IntroView: View {
    
    // MARK: Animation Properties
    @State var showWalkThroughScreens: Bool = false
    @State var currentIndex: Int = 0
    var body: some View {
        ZStack {
            Color("bg")
                .ignoresSafeArea()
            
            IntroScreen()
            
            WalkThroughScreens()
            
            NavBar()
        }
        .animation(.interactiveSpring(response: 1.1, dampingFraction: 0.85, blendDuration: 0.85), value: showWalkThroughScreens)
    }
    
    
    @ViewBuilder
    func IntroScreen() -> some View {
        GeometryReader { prox in
            let size = prox.size
            
            VStack(spacing: 10) {
                Image("Frame")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("Clearhead")
                    .font(.system(size: 27))
                    .padding(.top, 55)
                
                Text("In this Video I'm going to teach how to create Stylish App Intro Animation's  Using SwiftUI 4.0 | SwiftUI App Intro UI | SwiftUI Walkthrough Page Animation")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14))
                    .padding(.horizontal, 30)
                
                Text("Let's Begin")
                    .font(.system(size: 14))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background {
                        Capsule()
                            .fill(Color("blue"))
                    }
                    .onTapGesture {
                        showWalkThroughScreens.toggle()
                    }
                    .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            // MARK: Moving Up WHen Click
            .offset(y: showWalkThroughScreens ? -size.height : 0)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func NavBar() -> some View {
        HStack {
            Button {
                if currentIndex > 0 {
                    currentIndex -= 1
                }else {
                    showWalkThroughScreens.toggle()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("blue"))
            }
            
            Spacer()
            
            Button("Skip") {
                
            }
            .font(.system(size: 14))
            .foregroundColor(Color("blue"))
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .offset(y: showWalkThroughScreens ? 0 : -120)
    }
}


// MARK: WalkThrough screen
extension IntroView {
    @ViewBuilder
    func WalkThroughScreens() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                
                ForEach(sample_datas.indices, id:\.self) { index in
                    ScreenView(size: size, index: index)
                }
                
                WelcomeView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width: 55, height: 55)
                    .foregroundColor(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color("blue"))
                    }
                    .onTapGesture {
                        currentIndex += 1
                    }
                    .offset(y: -90)
            }
            .offset(y: showWalkThroughScreens ? 0 : size.height)
        }
    }
}


extension IntroView {
    @ViewBuilder
    func ScreenView(size: CGSize, index: Int) -> some View {
        let intro = sample_datas[index]
        
        VStack(spacing: 10) {
            Text(intro.title)
                .font(.system(size: 28))
            // MARK: Applying offset for each screen's
                .offset(x: -size.width * CGFloat(currentIndex - index))
            // MARK: Adding Animation
            // adding delay to element's based on index
            // my delay starts from top you can also modify code to start delay from bottom
            // 0.2, 0.1, 0
            // adding extra o.2 for current index
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Text(dummpText)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Image(intro.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250, alignment: .top)
                .padding(.horizontal, 20)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
        }
        
        
    }
    
    @ViewBuilder
    func WelcomeView() -> some View {
        VStack(spacing: 10) {
            // 这里搞一些图片和文字
            
        }
    }
    
    
}



struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
