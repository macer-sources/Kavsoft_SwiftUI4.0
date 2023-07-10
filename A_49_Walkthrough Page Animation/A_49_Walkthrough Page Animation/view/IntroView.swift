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
    
    var body: some View {
        ZStack {
            Color("bg")
                .ignoresSafeArea()
            
            IntroScreen()
            
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
                showWalkThroughScreens.toggle()
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

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
