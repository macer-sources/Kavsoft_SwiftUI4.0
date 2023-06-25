//
//  ContentView.swift
//  A_19_Matched Geometry Effect Masking
//
//  Created by Kan Tao on 2023/6/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var expandCard = false
    @State var showContent: Bool = false
    @Namespace var animation
    
    var body: some View {
        VStack {
            // MARK: Header
            HStack {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Pay")
                }
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("BACK")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            
            CardView()
            
            // MARK: Footer Content
            
            Text("Woohoo!")
                .font(.system(size: 35, weight: .bold))
            
            Text("In this Video I'm going to teach how to create Stylish Scratch/Gift Card Effect Combined With Matched Geometry Effect And Lottie Animations  Using SwiftUI")
                .kerning(1.02)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            Button {
                
            } label: {
                Text("VIEW BALANCE")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 17)
                    .frame(maxWidth: .infinity)
                    .background {
                        Rectangle()
                            .fill(.linearGradient(colors: [Color("purple"), Color("purple 1")], startPoint: .leading, endPoint: .trailing))
                    }
            }
            .padding(.top, 15)

        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background{Color("bg").ignoresSafeArea()}
        .overlay(content: {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(showContent ? 1 : 0)
                .ignoresSafeArea()
        })
        .overlay(content: {
            GeometryReader { proxy in
                let size = proxy.size
                if expandCard {
                    // by padding 15 + 15 = 30
                    GiftCard(size: size)
                        .overlay(content: {
                            // MARK: Lottie animation
                            
                        })
                        .matchedGeometryEffect(id: "GIFTCARD", in: animation)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(x: 1)))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showContent = true
                            }
                        }
                }
            }
            .padding(30)
        })
        .overlay(alignment: .topTrailing, content: {
            Button {
                withAnimation(.easeInOut(duration: 0.35)) {
                    showContent = false
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                    expandCard = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(15)
            }

        })
        .preferredColorScheme(.dark)
    }
    
    
    
    @ViewBuilder
    func CardView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            ScratchCardView(pointSize: 60) {
                // MARK: Gift Card
                if !expandCard {
                    GiftCard(size: size)
                        .matchedGeometryEffect(id: "GIFTCARD", in: animation)
                }
            } overlay: {
                Image("card")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width * 0.9, height: size.height * 0.9, alignment: .topLeading)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } onFinish: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        expandCard = true
                        
                    }
                }
            }
            .frame(width: size.width, height: size.height, alignment: .center)

        }
        .padding(15)
    }
    
    
    @ViewBuilder
    func GiftCard(size: CGSize) -> some View {
        VStack(spacing: 18) {
            Image("trophy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
            
            Text("You Wan")
                .font(.callout)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "applelogo")
                    .offset(y: -3)
                Text("$59")
            }
            .font(.title.bold())
            .foregroundColor(.black)
            
            Text("It will be credited within 24 hours")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(20)
        .frame(width: size.width * 0.9,height: size.height * 0.9)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
