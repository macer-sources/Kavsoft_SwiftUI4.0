//
//  RollingText.swift
//  A_13_Rolling Counter
//
//  Created by Kan Tao on 2023/6/20.
//

import SwiftUI

struct RollingText: View {
    var font: Font = .largeTitle
    var weight: Font.Weight = .regular
    @Binding var value: Int
    
    // Animation Properties
    @State private var animationRange:[Int] = []
    
    var body: some View {
        HStack {
            ForEach(0..<animationRange.count,id: \.self) { index in
                // TODO: 创建和[char]相等的 数字，然后每个数字上，垂直包含 0～ 9 个数， 根据当前所在数，进行显示对应数字
                Text("0")
                    .font(font)
                    .fontWeight(weight)
                    .opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size

                            VStack(spacing: 0) {
                                // MARK: Since its individual value
                                // we need from 0-9
                                ForEach(0...9, id:\.self) { numer in
                                    Text("\(numer)")
                                        .font(font)
                                        .fontWeight(weight)
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                }
                            }
                            .offset(y: -CGFloat(animationRange[index]) * size.height)
                        }
                        .clipped()
                    }
            }
        }
        .onAppear {
            // 根据字符串长度，创建一个数组， 全部为 0
            animationRange = Array(repeating: 0, count: "\(value)".count)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateText()
            }
        }
        .onChange(of: value) { newValue in
            let extra = "\(value)".count - animationRange.count
            if extra > 0 {
                for _ in 0..<extra {
                    withAnimation(.easeIn(duration: 0.1)) {
                        animationRange.append(0)
                    }
                }
            }else
            {
                for _ in 0..<(-extra) {
                    withAnimation(.easeIn(duration: 0.1)) {
                       _ = animationRange.removeLast()
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                updateText()
            }
        }
    }
    
    
    func updateText() {
        // 将value ---> [char]
        let stringValue = "\(value)"
        for(index, value) in zip(0..<stringValue.count, stringValue) {
            var fraction = Double(index) * 0.15
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
                animationRange[index] = (String(value) as NSString).integerValue
            }
        }
    }
    
}

struct RollingText_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
