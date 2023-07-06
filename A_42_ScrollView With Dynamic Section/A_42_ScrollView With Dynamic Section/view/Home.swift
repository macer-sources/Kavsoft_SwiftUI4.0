//
//  Home.swift
//  A_42_ScrollView With Dynamic Section
//
//  Created by Kan Tao on 2023/7/6.
//

import SwiftUI

struct Home: View {
    // MARK: View Properties
    @State var characters:[Character] = []
    
    // MARK: Gesture Properties
    @GestureState var isDragging: Bool = false
    @State var offsetY: CGFloat = 0
    
    @State var currentActiveIndex: Int = 0
    var body: some View {
        NavigationStack {
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
                    .padding(.trailing, 100)
                }
                .onChange(of: currentActiveIndex) { newValue in
                    // MARK: Scrolling to current index
                    withAnimation {
                        proxy.scrollTo(currentActiveIndex, anchor: .top)
                    }
                }
            })
            .navigationTitle("Contact's")
        }
        
        .overlay(alignment: .trailing, content: {
            CustomScroller()
                .padding(.top, 35)
        })
        .onAppear {
            characters = fetchingCharacters()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                characterElevation()
            }
        }
    }
    
    
    // MARK: Custom Scroll Bar
    @ViewBuilder
    func CustomScroller() -> some View {
        GeometryReader { proxy in
            let rect  = proxy.frame(in: .named("SCROLLER"))
            VStack(spacing: 0) {
                ForEach($characters) { $char in
                    HStack(spacing: 15) {
                        GeometryReader { innerProxy in
                            let origin = innerProxy.frame(in: .named("SCROLLER"))
                            Text(char.value)
                                .font(.callout)
                                .fontWeight(char.isCurrent ? .bold : .semibold)
                                .foregroundColor(char.isCurrent ?  .black : .gray)
                                .scaleEffect(char.isCurrent ? 1.4 : 0.8)
                                .contentTransition(.interpolate)
                                .frame(width: origin.size.width, height: origin.size.height, alignment: .trailing)
                                .overlay {
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(width: 15, height: 0.8)
                                        .offset(x: 35)
                                }
                                .offset(x: char.pushOffset)
                                .animation(.easeInOut(duration: 0.2), value: char.pushOffset)
                                .animation(.easeInOut(duration: 0.2), value: char.isCurrent)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        // MARK: Storing origin
                                        char.rect = origin
                                    }
                                }
                                
                        }
                        .frame(width: 20)
                        
                        ZStack {
                            if characters.first?.id == char.id {
                                ScrollerKnob(char: $char, rect: rect)
                            }
                        }
                        .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .frame(width: 55)
        .coordinateSpace(name: "SCROLLER")
        .padding(.trailing, 10)
        .padding(.vertical, 15)
    }
    
    
    
    @ViewBuilder
    func ScrollerKnob(char: Binding<Character>, rect: CGRect) -> some View {
        Circle()
            .fill(.black)
            // MARK: Scaling Animation
            .overlay(content: {
                Circle()
                    .fill(.white)
                    .scaleEffect(isDragging ? 0.8 : 0.0001)
            })
            .scaleEffect(isDragging ? 1.35 : 1)
            .animation(.easeInOut(duration: 0.2), value: isDragging)
            .offset(y: offsetY)
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($isDragging, body: { value, out, _ in
                        out = true
                    })
                    .onChanged({ value in
                        // MARK: Setting location
                        var translation = value.location.y - 20
                        // TODO: 这里考虑了 knob size
                        translation = min(translation, rect.maxY - 20)
                        translation = max(translation, rect.minY)
                        
                        offsetY = translation
                        
                        characterElevation()
                    })
                    .onEnded({ value in
                        // MARK: Setting to last character location
                        if characters.indices.contains(currentActiveIndex) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                offsetY = characters[currentActiveIndex].rect.minY
                            }
                        }
                    })
            )
    }
    
    
    // MARK: Checking For Character Elevation When Gesture is Started
    func characterElevation() {
        if let index = characters.firstIndex(where: { char in
            char.rect.contains(CGPoint.init(x: 0, y: offsetY))
        }) {
            
            // MARK: modified indices array
            var modifiedIndicies:[Int] = []
            
            // MARK: Updating Side Offset
            characters[index].pushOffset = -35
            characters[index].isCurrent = true
            currentActiveIndex = index
            modifiedIndicies.append(index)
            
            // MARK: Updating top and bottom 3 offset's in order to create a curve animation
            let otherOffsets:[CGFloat] = [-25,-15,5]
            // 可以自定义
            for index_ in otherOffsets.indices {
                // eg index + 1, index +2, index +3
                let newIndex = index + (index_ + 1)
                // MARK: Top Indexes (negative)
                // eg index - 1, index - 2, index - 3
                let newIndex_negative = index - (index_ + 1)
                
                if verifyAndUpdate(index: newIndex, offset: otherOffsets[index_]) {
                    modifiedIndicies.append(newIndex)
                }
                
                if verifyAndUpdate(index: newIndex_negative, offset: otherOffsets[index_]) {
                    modifiedIndicies.append(newIndex_negative)
                }
            }
            
            // MARK: Setting remaining all characters offset to zero
            for index_ in characters.indices {
                if !modifiedIndicies.contains(index_) {
                    characters[index_].pushOffset = 0
                    characters[index_].isCurrent = false
                }
            }
        }
    }
    
    // MARK: Safety check
    func verifyAndUpdate(index: Int, offset: CGFloat) -> Bool {
        if characters.indices.contains(index) {
            characters[index].pushOffset = offset
            characters[index].isCurrent = false
            return true
        }
        return false
    }
    
    
    
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
