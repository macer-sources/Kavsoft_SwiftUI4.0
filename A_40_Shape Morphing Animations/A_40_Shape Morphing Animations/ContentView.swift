//
//  ContentView.swift
//  A_40_Shape Morphing Animations
//
//  Created by Kan Tao on 2023/7/6.
//

import SwiftUI

struct ContentView: View {
    @State var currentImage: CustomShape = .cloud
    @State var pickerImage: CustomShape = .cloud
    @State var turnOffImageMorph: Bool = false
    @State var blurRadius: CGFloat = 0
    @State var animateMorph: Bool = false
    
    
    var body: some View {
        VStack {
            // MARK: Image Morph is simple
            // simply mask the canvas shape as Image mask
            GeometryReader { proxy in
                let size = proxy.size
                Image("image2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .overlay(content: {
                        Rectangle()
                            .fill(.white)
                            .opacity(turnOffImageMorph ? 1 : 0)
                    })
                    .mask {
                        // MARK: Morphing shapes with the help of canvas and filters
                        Canvas { context, size in
                            // for more morph shape link
                            // mark: for more morph shape link change this
                            
                            
                            
                            // MARK: Morphing Filters
                            // TODO: 这里是形变的重点， 添加了filter
                            context.addFilter(.alphaThreshold(min: 0.3))
                            // 此值在变形动画中起着重要作用
                            // 这里动画值的变化：0～ 20 相对 0～1。  第一个image
                            //                20 ~ 40 相对 1 ～ 0。第二个image
                            context.addFilter(.blur(radius: blurRadius > 20 ? 20 - (blurRadius - 20) : blurRadius))
                            
                           // MARK: Draw inside layer
                            context.drawLayer { ctx in
                                if let resolvedImage = context.resolveSymbol(id: 1) {
                                    ctx.draw(resolvedImage, at: CGPoint.init(x: size.width / 2, y: size.height / 2), anchor: .center)
                                }
                            }
                        }symbols: {
                            // MARK: Giving Images with id
                            ResolvedImage(currentImage: $currentImage)
                                .tag(1)
                        }
                        
                        // TODO: 动画在canvas 中是无法工作， 可以使用 Timeline view 模拟动画执行过程
                        // 这里使用 timer 简单的模型实现效果
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common
                                                ).autoconnect()) { _ in
                            if !animateMorph {
                                return
                            }
                            
                            if blurRadius <= 40 {
                                blurRadius += 0.5
                                
                                if blurRadius.rounded() == 20 {
                                    // MARK: Change of next image goes here
                                    currentImage = pickerImage
                                }
                            }
                            
                            if blurRadius.rounded() == 40 {
                                // MARK: End Animation and reset the blur radius to zero
                                animateMorph = false
                                blurRadius = 0
                            }
                        }
                    }
            }
            .frame(height: 400)
            
            // MARK: Segmentd picker
            Picker("", selection: $pickerImage) {
                ForEach(CustomShape.allCases, id: \.rawValue) { shape in
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
            }
            .pickerStyle(.segmented)
            // MARK: Avoid tap until the current animation is finished
            .overlay(content: {
                Rectangle()
                    .fill(.primary)
                    .opacity(animateMorph ? 0.05 : 0)
            })
            .padding(15)
            .padding(.top, -50)
            // MARK: When ever picker image change
            // morphing into new shape
            .onChange(of: pickerImage) { newValue in
                animateMorph = true
            }
            
            Toggle("Turn Off Image Morph", isOn: $turnOffImageMorph)
                .fontWeight(.semibold)
                .padding(.horizontal, 15)
                .padding(.top, 10)
            
//            Slider(value: $blurRadius, in:0...40)
        }
        .offset(y: -50)
        .frame(maxHeight: .infinity, alignment: .top)
        .preferredColorScheme(.dark)
    }
}


struct ResolvedImage: View {
    @Binding var currentImage: CustomShape
    var body: some View {
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8), value: currentImage)
            .frame(width: 300, height: 300)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
