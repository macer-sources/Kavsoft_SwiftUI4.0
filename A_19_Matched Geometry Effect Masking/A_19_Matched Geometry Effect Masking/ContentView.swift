//
//  ContentView.swift
//  A_19_Matched Geometry Effect Masking
//
//  Created by Kan Tao on 2023/6/25.
//

import SwiftUI

struct ContentView: View {
    
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
        .background(Color("bg").ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
    
    
    
    @ViewBuilder
    func CardView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            ScratchCardView(pointSize: 60) {
                // MARK: Gift Card
                GiftCard(size: size)
            } overlay: {
                Image("card")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width * 0.9, height: size.height * 0.9, alignment: .topLeading)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } onFinish: {
                debugPrint("Finished")
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
