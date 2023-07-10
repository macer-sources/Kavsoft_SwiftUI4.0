//
//  Home.swift
//  A_50_Animated ScrollView Indicator Labelling
//
//  Created by Kan Tao on 2023/7/10.
//

import SwiftUI

struct Home: View {
    @State var characters:[Character] = []
    @State var scrollerHeight: CGFloat = 0
    @State var indicatorOffset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    
    
    @State var hideIndicatorLabel: Bool = false
    
    
    // MARK: Scrollview enddeclaration properties
    @State var timeOut: CGFloat = 0.3
    
    
    @State var currentCharacter: Character = .init(value: "")
    var body: some View {
        NavigationStack(root: {
            GeometryReader { proxy in
                let size = proxy.size
                
                ScrollViewReader(content: {proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // MARK: Sample Contacts View
                            ForEach(characters) { char in
                                ContactsForCharacter(character: char)
                                    .id(char.index)
                            }
                        }
                        .padding(.top, 15)
                        .padding(.trailing, 20)
                        .offset { rect in
                            // MARK: When Ever Scrolling Does
                            // resetting time out
                            if hideIndicatorLabel && rect.minY < 0 {
                                timeOut = 0
                                hideIndicatorLabel = false
                            }
                            
                            
                            // MARK: Finding scroll indicator height(rect scroll offset)
                            let rectHeight = rect.height
                            let viewHeight = size.height + (startOffset / 2)
                            
                            let scrollerHeight = (viewHeight / rectHeight) * viewHeight
                            self.scrollerHeight = scrollerHeight
                            
                            // MARK: Finding scroll indicator offset
                            let progress = rect.minY / (rectHeight - size.height)
                            // MARK: Simply Multiply with view height (eliminating scroller height)
                            self.indicatorOffset = -progress * (size.height - scrollerHeight)
                        }
                    }
                })
                .coordinateSpace(name: "SCROLLER")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .topTrailing) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 2, height: scrollerHeight)
                        .overlay(alignment: .trailing, content: {
                            // MARK: Bulle Image
                            Image(systemName: "bubble.middle.bottom.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 45, height: 45)
                                .environment(\.colorScheme, .dark)
                                .rotationEffect(.init(degrees: -90))
                                .overlay(content: {
                                    Text(currentCharacter.value)
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                        .offset(x: -3)
                                })
                                .offset(x: hideIndicatorLabel || currentCharacter.value == "" ? 65 : 0)
                                .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6), value: hideIndicatorLabel || currentCharacter.value == "")
                                
                        })
                        .padding(.trailing, 5)
                        .offset(y: indicatorOffset)
                    
                }
            }
            .navigationTitle("Contact's")
            .offset { rect in
                if startOffset != rect.minY {
                    startOffset = rect.minY
                }
            }
        })
        .onAppear {
           characters = fetchingCharacters()
        }
        // MARK: I'm going to implement a custom scrollView end declaration with the help of the timer and offset values
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()) { value  in
            
            if timeOut < 0.3 {
                timeOut += 0.01
            }else {
                // MARK: Scrolling is Finished
                // it will fire many times so use some conditions here
                if !hideIndicatorLabel {
                    print("Scrolling is Finished")
                    hideIndicatorLabel = true
                }
            }
            
        }
    }
}


extension Home {
    // MARK: Contact Row For Each Alphabet
    @ViewBuilder
    func ContactsForCharacter(character: Character) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(character.value)
                .font(.largeTitle.bold())
            ForEach(1...4, id: \.self) { index  in
                HStack(spacing: 10) {
                    Circle().fill(character.color.gradient)
                        .frame(width: 45, height: 45)
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(character.color.opacity(0.4).gradient)
                            .frame(height: 20)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(character.color.opacity(0.6).gradient)
                            .frame(height: 20)
                            .padding(.trailing, 80)
                    }
                }
            }
        }
        .offset(completion: { rect in
            // MARK: Verifying which section is at the top (near nav bar)
            // updating character rect when ever it's updated
            if characters.indices.contains(character.index) {
                characters[character.index].rect = rect
            }
            // Since every character moves up and goes beyond zero (it will be like A, B,C,D)
            // so we're taking the last character
            
            if let last = characters.last(where: {$0.rect.minY < 0}), last.id != currentCharacter.id {
                currentCharacter = last
                print(character.value)
            }
            
            
        })
        .padding(15)
    }
    
    // MARK: Fetching Characters
    func fetchingCharacters() -> [Character] {
        let alphabets:String = "ABCDEFGHIGKLMNOPQRSTUVWXYZ"
        var characters = alphabets.compactMap { char -> Character in
            return Character.init(value: String(char))
        }
        
        let colors:[Color] = [.red,.yellow,.pink,.orange,.cyan,.indigo,.purple,.blue]
        
        // MARK: Setting Index And Random Color
        for index in characters.indices {
            characters[index].index = index
            characters[index].color = colors.randomElement() ?? .red
        }
        return characters
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}




// MARK: Offset Reader
extension View {
    @ViewBuilder
    func offset(completion:@escaping (CGRect) -> Void) -> some View {
        self.overlay {
            GeometryReader {
                let rect = $0.frame(in: .named("SCROLLER"))
                Color.clear
                    .preference(key: OffsetKey.self, value: rect)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}

// MARK: Offset Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

