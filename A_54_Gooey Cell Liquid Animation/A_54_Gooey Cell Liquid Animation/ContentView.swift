//
//  ContentView.swift
//  A_54_Gooey Cell Liquid Animation
//
//  Created by Kan Tao on 2023/7/14.
//

import SwiftUI

struct ContentView: View {
    @State private var samples:[Promotion] = samples_data
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                HeaderView()
                    .padding(15)
                
                ForEach(samples) { sample in
                    GooeyCell(model: sample) {
                        samples.removeAll(where: {$0.id == sample.id})
                    }
                }
            }
            .padding(.vertical, 18)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
        }
    }
    
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Text("Promotions")
                .font(.system(size: 38))
                .fontWeight(.medium)
                .foregroundColor(.green)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.green)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct GooeyCell: View {
    var model: Promotion
    var onDelete:() -> Void = {}
    
    var icon: String = "xmark"
    //MARK: Animation Properties
    @State var offsetX: CGFloat = 0
    @State var cardOffset: CGFloat = 0
    @State var finishAnimation: Bool = false
    var body: some View {
        let cardWidth = screenSize().width - 35
        let progress = (-offsetX * 0.8) / screenSize().width
        
        ZStack {
            CanvasView()
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(model.logo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                        Text(model.name)
                            .font(.callout)
                            .fontWeight(.semibold)
                    }
                    
                    Text(model.title)
                        .foregroundColor(.black.opacity(0.8))
                    
                    Text(model.subTitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .lineLimit(1)
                
                Spacer()
                
                Text("29 OTC")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.green.opacity(0.7))
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white.opacity(0.7))
            }
            .opacity(1.0 - progress)
            .blur(radius: progress * 5.0)
            .padding(.horizontal, 15)
            .contentShape(Rectangle())
            .offset(x: cardOffset)
            .gesture(
                DragGesture()
                .onChanged({ value in
                    
                    // MARK: Only Left Swipe
                    var translation = value.translation.width
                    translation = (translation > 0 ? 0 : translation)
                    // MARK: Stopping the Card End
                    translation = (-translation < cardWidth ? translation : -cardWidth)
                    offsetX = translation
                    cardOffset = offsetX
                }).onEnded({ value in
                    // MARK: Release Animation
                    if -value.translation.width > (screenSize().width * 0.6) {
                        // MARK: Haptic Feedback
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        finishAnimation = true
                        
                        // moving card outside of the screen
                        withAnimation(.easeInOut(duration: 0.3)) {
                            cardOffset = -screenSize().width
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onDelete()
                        }
                        
                    }else {
                        withAnimation {
                            offsetX = .zero
                            cardOffset = .zero
                        }
                    }
                })
            )
        }

    }
    
    
    // MARK: Implementing Gooey Cell Animation
    // for more about fluid animation
    // check out my shape morphing video's, link in the description
    
    @ViewBuilder
    func CanvasView() -> some View {
        let width = screenSize().width * 0.8
        let scale = finishAnimation ? -0.0001 :  offsetX / width
        let circleOffset = offsetX / width
        
        Canvas {ctx, size in
            // Since We Applied Effect Here, it will be smooth
            ctx.addFilter(.alphaThreshold(min: 0.5, color: .green))
            ctx.addFilter(.blur(radius: 5))
            
            ctx.drawLayer { layer in
                if let resolvedView = ctx.resolveSymbol(id: 1) {
                    layer.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                }
            }
        }symbols: {
            GooeyView()
                .tag(1)
        }
        // MARK: Icon View
        .overlay(alignment: .trailing) {
            Image(systemName: icon)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 42, height: 42)
                .offset(x: 42)
                .offset(x: (-circleOffset < 1.0 ? circleOffset : -1.0) * 42)
                .offset(x: offsetX * 0.2)
                .offset(x: 8)
                .offset(x: finishAnimation ? -200 : 0)
                .opacity(finishAnimation ? 0 : 1)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 1, blendDuration: 1), value: finishAnimation)
        }
    }
    
    @ViewBuilder
    func GooeyView() -> some View {
        let width = screenSize().width * 0.8
        let scale = offsetX / width
        let circleOffset = offsetX / width
        
        Image("shape")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 100)
            .scaleEffect(x:-scale, anchor: .trailing)
            // MARK: Adding some Y Scaling
            .scaleEffect(y: 1 + (-scale / 5), anchor: .center)
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: finishAnimation)
            // MARK: Adding Icon View
            .overlay(alignment: .trailing,content: {
                Circle()
                    .frame(width: 42, height: 42)
                // MARK: Moving view inside
                    .offset(x: 42)
                    .scaleEffect(finishAnimation ? 0.001 : 1, anchor: .leading)
                    .offset(x: (-circleOffset < 1.0 ? circleOffset : -1.0) * 42)
                    .offset(x: offsetX * 0.2)
                    .offset(x: finishAnimation ? -200 : 0)
                    .animation(.interactiveSpring(response: 0.6, dampingFraction: 1, blendDuration: 1), value: finishAnimation)
                
                
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .offset(x: 8)

    }
    
}


extension View {
    func screenSize() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
}
