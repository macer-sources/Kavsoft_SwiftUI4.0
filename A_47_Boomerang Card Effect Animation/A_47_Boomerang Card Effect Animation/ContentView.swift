//
//  ContentView.swift
//  A_47_Boomerang Card Effect Animation
//
//  Created by Kan Tao on 2023/7/7.
//

import SwiftUI

struct ContentView: View {
    @State var samples:[Card] = []
    
    // MARK: View Properties
    @State var isBlurEnabled = false
    @State var isRotationEnabled = true
    
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle("Enable Blur", isOn: $isBlurEnabled)
            Toggle("Turn On Rotation", isOn: $isRotationEnabled)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            BoomerangCard(isBlurEnabled: isBlurEnabled, isRotationEnabled: isRotationEnabled, cards: $samples)
                .frame(height: 220)
                .padding(.horizontal, 15)
                .padding(.bottom, 40)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background {
            Color("Color")
                .ignoresSafeArea()
        }
        
        .preferredColorScheme(.dark)
        .onAppear {
            for index in 1...6 {
                samples.append(Card.init(image: "image\(index)"))
            }
            // For infinite cards
            // logic is simple , place the first card at last when the last card is arrived, set index to 0
            if var first = samples.first {
                first.id =  UUID().uuidString
                samples.append(first)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: Boomerang Card View
struct BoomerangCard: View {
    var isBlurEnabled:Bool
    var isRotationEnabled:Bool
    @Binding var cards:[Card]
    
    
    // MARK: Gesture properties
    @State var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                ForEach(cards.reversed()) { card in
                    CardView(card: card, size: size)
                        // MARK: Moving only current active card
                        .offset(y: currentIndex == indexOf(card: card) ? offset : 0)
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: offset == .zero)
            .frame(width: size.width, height: size.height)
            .contentShape(Rectangle())
//            .clipShape(RoundedRectangle(cornerRadius: 20))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = currentIndex == cards.count - 1 ? 0 : value.translation.height
                    })
                    .onEnded({ value in
                        var translation = value.translation.height
                        // Since we only need negative
                        translation = translation < 0 ? -translation : 0
                        translation = currentIndex == cards.count - 1 ? 0 : translation
                        
                        
                        // MARK: Since Our card height = 220
                        if translation > 110 {
                            // MARK: Doing Boomerang effect and updating current index
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6,blendDuration: 0.6)) {
                                cards[currentIndex].isRotated = true
                                cards[currentIndex].extraOffset = -350
                                cards[currentIndex].scale = 0.7
                            }
                            
                            // After a little delay resetting gesture offset and extra offset
                            // pushing card into back using zindex
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6,blendDuration: 0.6)) {
                                    cards[currentIndex].zIndex = -100
                                    for index in cards.indices {
                                        cards[index].extraOffset = 0
                                    }
                                    // MARK: Updating current index
                                    if currentIndex != cards.count - 1 {
                                        currentIndex += 1
                                    }
                                    
                                    offset = .zero
                                }
                            }
                            
                            // Ater animation completed resetting rotation and scaling and setting properties zinde value
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                for index in cards.indices {
                                    if index == currentIndex {
                                        // MARK: Placing the card at right index
                                        // since the current index is updated +1 previously
                                        if cards.indices.contains(currentIndex - 1) {
                                            cards[currentIndex - 1].zIndex = zIndex(card: cards[currentIndex - 1])
                                        }
                                    }else {
                                        cards[index].isRotated = false
                                        withAnimation(.linear) {
                                            cards[index].scale = 1
                                        }
                                    }
                                }
                                
                                
                                if currentIndex == cards.count - 1 {
                                    // resetting index to 0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        for index in cards.indices {
                                            // resetting zindex
                                            cards[index].zIndex = 0
                                        }
                                        currentIndex = 0
                                    }
                                }
                                
                                
                            }
                            
                            
                        }else {
                            offset = .zero
                        }
                    })
            )
        }
    }
    
    //
    func zIndex(card: Card)-> Double {
        let index = indexOf(card: card)
        let totalCount = cards.count
        
        return currentIndex > index ? Double(index - totalCount) : cards[index].zIndex
    }
    
    
    
    @ViewBuilder
    func CardView(card: Card, size: CGSize) -> some View {
        let index = indexOf(card: card)
        Image(card.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height) // TODO: 这里必是有用的，不然 image 将按照它自己的高度进行展示,如果这里不用，就需要在 zstack 上进行 clipShape
            .blur(radius: card.isRotated && isBlurEnabled ? 6.5 : 0)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(card.scale, anchor: card.isRotated ? .center : .top)
            .rotation3DEffect(.init(degrees: isRotationEnabled && card.isRotated ? 360 : 0), axis: (x: 0, y: 0, z: 1))
            .offset(y: -offsetFor(index: index))
            .offset(y: card.extraOffset)
            .scaleEffect(scaleFor(index: index), anchor: .top)
            .zIndex(card.zIndex)
            
            
    }
    
    
    
    // MARK: Scale And Offset Values For Each Card
    func scaleFor(index value: Int) -> Double {
        let index = Double(value - currentIndex)
        // MARK: i'M only showing tree cards
        if index >= 0 {
            if index > 3 {
                return 0.8
            }
            return 1 - (index / 15)
        }else {
            if -index > 3 {
                return 0.8
            }
            return 1 + (index / 15)
        }
    }
    func offsetFor(index value: Int) -> Double {
        let index = Double(value - currentIndex)
        // MARK: i'M only showing tree cards
        if index >= 0 {
            if index > 3 {
                return 30
            }
            return (index * 10)
        }else {
            if -index > 3 {
                return 30
            }
            return (-index * 10)
        }
    }
    
    func indexOf(card: Card)-> Int {
        return cards.firstIndex { c in
            c.id == card.id
        } ?? 0
    }
    
}

