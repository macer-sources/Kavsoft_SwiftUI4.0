//
//  IntroView.swift
//  A_49_Walkthrough Page Animation
//
//  Created by Kan Tao on 2023/7/10.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        ZStack {
            Color("bg")
                .ignoresSafeArea()
            
            IntroScreen()
        }
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
                        
                    }
                    .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea()
    }
    
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
