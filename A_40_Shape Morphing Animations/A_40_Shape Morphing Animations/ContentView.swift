//
//  ContentView.swift
//  A_40_Shape Morphing Animations
//
//  Created by Kan Tao on 2023/7/6.
//

import SwiftUI

struct ContentView: View {
    @State var currentImage: CustomShape = .cloud
    var body: some View {
        VStack {
            // MARK: Morphing shapes with the help of canvas and filters
            Canvas { context, size in
                if let resolvedImage = context.resolveSymbol(id: 1) {
                    context.draw(resolvedImage, at: CGPoint.init(x: size.width / 2, y: size.height / 2), anchor: .center)
                }
            }symbols: {
                // MARK: Giving Images with id
                ResolvedImage(currentImage: $currentImage)
                    .tag(1)
            }
            .frame(height: 350)
            
            // MARK: Segmentd picker
            Picker("", selection: $currentImage) {
                ForEach(CustomShape.allCases, id: \.rawValue) { shape in
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
            }
            .pickerStyle(.segmented)
            .padding(15)
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
