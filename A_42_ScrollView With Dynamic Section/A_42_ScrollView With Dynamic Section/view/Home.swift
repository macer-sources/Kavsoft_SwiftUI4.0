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
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: Sample Contacts View
                    ForEach(characters) { char in
                        ContactsForCharacter(character: char)
                    }
                }
                .padding(.top, 15)
                .padding(.trailing, 100)
            }
            .navigationTitle("Contact's")
        }
        
        .overlay(alignment: .trailing, content: {
            CustomScroller()
        })
        .onAppear {
            characters = fetchingCharacters()
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
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .frame(width: origin.size.width, height: origin.size.height, alignment: .trailing)
                                .overlay {
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(width: 15, height: 0.8)
                                        .offset(x: 35)
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
        .background(.red)
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
                        var translation = value.location.y
                        translation = min(translation, rect.maxY - 20)
                        translation = max(translation, rect.minY)
                        
                        offsetY = translation
                    })
                    .onEnded({ value in
                        
                    })
            )
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
