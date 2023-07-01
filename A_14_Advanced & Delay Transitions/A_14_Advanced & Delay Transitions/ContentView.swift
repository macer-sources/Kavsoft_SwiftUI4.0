//
//  ContentView.swift
//  A_14_Advanced & Delay Transitions
//
//  Created by Kan Tao on 2023/6/20.
//

import SwiftUI

struct ContentView: View {
    @State private var chat:[Message] = [
        Message(message: "In this Video I'm going to teach how to create Stylish Custom Context Menu Reactions Like iMessages App With Anchor Preferences Using SwiftUI - SwiftUI Facebook Reactions | SwiftUI Custom Context Menu | SwiftUI Anchor Preferences"),
        Message(message: "Awesome. Love to see deep dives like this. Maybe new Layout protocol? Great detail with the sparks, amazing work!!! (as always) That’s amazing lessons…🔥✨💯 thank you Variable binding in a condition requires an initializer at 3:58. Any idea?", isReply: true)
    ]
    
    
    @State var hightlightChat: Message?
    @State var showHightlight: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(content: {
                VStack(spacing: 12) {
                    ForEach(chat) { chat in
                        VStack(alignment: chat.isReply ? .leading : .trailing) {
                            if chat.isEmojiAdded {
                                AnimatedEmoji(emoji: chat.emojiValue, color: chat.isReply ? .blue : .gray.opacity(0.5))
                                    .offset(x: chat.isReply ? -15 : 15)
                                    .padding(.bottom, -25)
                                    .zIndex(1)
                                    .opacity(showHightlight ? 0 : 1)
                            }
                            ChatView(message: chat)
                            // 使用锚点首选项读取视图锚点值（bounds）
                                .anchorPreference(key: BoundsPreferences.self, value: .bounds, transform: { anchor in
                                    return [chat.id : anchor]
                                })
                        }
                        .padding(chat.isReply ? .leading : .trailing, 60)
                        .onLongPressGesture {
                            withAnimation {
                                showHightlight = true
                                hightlightChat = chat
                            }
                        }
                    }
                }
                .padding()
            })
            .navigationTitle("Transitions")
        }
        .overlay(content: {
            if showHightlight {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showHightlight = false
                            hightlightChat = nil
                        }
                    }
            }
        })
        .overlayPreferenceValue(BoundsPreferences.self) { values in
            if let hightlightChat, let preference = values.first(where: { item in
                item.key == hightlightChat.id
            }) {
                //
                GeometryReader { proxy in
                    let rect = proxy[preference.value]
                    
                    ChatView(message: hightlightChat, showLike: true)
                        .id(hightlightChat.id)
                        .frame(width: rect.width, height: rect.height)
                        .offset(x: rect.minX, y: rect.minY)
                }
                // TODO: 过度动画
                .transition(.asymmetric(insertion: .identity, removal: .offset(x: 1)))
            }
        }
    }
}


extension ContentView {
    @ViewBuilder
    func ChatView(message: Message, showLike: Bool = false) -> some View {
        ZStack(alignment: .bottomLeading) {
            Text(message.message)
                .padding(15)
                .background(message.isReply ? Color.gray.opacity(0.2) : Color.blue)
                .foregroundColor(message.isReply ? .black :  .white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            if showLike {
                EmojiView(hideView: $showHightlight,chat: message) { emoji in
                    // MARK: Close hightlight
                    withAnimation(.easeInOut) {
                        showHightlight = false
                        hightlightChat = nil
                    }
                    if let index = chat.firstIndex(where: { chat in
                        chat.id == message.id
                    }) {
                        withAnimation(.easeInOut.delay(0.3)) {
                            chat[index].isEmojiAdded = true
                            chat[index].emojiValue = emoji
                        }
                    }
                }
                .offset(y: 55)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct AnimatedEmoji: View {
    var emoji: String
    var color: Color = .blue
    
    // MARK: Animation Properties
    @State var animationValues:[Bool] = Array.init(repeating: false, count: 6)
    
    var body: some View {
        ZStack {
            Text(emoji)
                .font(.system(size: 25))
                .padding(6)
                .background {
                    Circle()
                        .fill(color)
                }
                .scaleEffect(animationValues[2] ? 1 : 0)
                .overlay {
                    Circle()
                        .stroke(color, lineWidth: animationValues[0] ? 0 : 100)
                        .clipShape(Circle())
                        .scaleEffect(animationValues[0] ? 1.6 : 0.01)
                }
            // MARK: Random Circles
                .overlay {
                    ZStack {
                        ForEach(1...20, id:\.self) { index in
                            Circle()
                                .fill(color)
                                .frame(width: .random(in: 3...5), height: .random(in: 3...5))
                                .offset(x: .random(in: -5...5), y: .random(in: -5...5))
                                .offset(x: animationValues[3] ? 45 : 10)
                                .rotationEffect(.init(degrees: Double(index) * 18))
                                .scaleEffect(animationValues[2] ? 1 : 0.01)
                                .opacity(animationValues[4] ? 0 : 1)
                        }
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    animationValues[0] = true
                }
                withAnimation(.easeInOut(duration: 0.45).delay(0.06)) {
                    animationValues[1] = true
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.3)) {
                    animationValues[2] = true
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.4)) {
                    animationValues[3] = true
                }
                withAnimation(.easeInOut(duration: 0.55).delay(0.55)) {
                    animationValues[4] = true
                }
            }
        }
    }
}



struct EmojiView: View {
    @Binding var hideView: Bool
    var chat: Message
    var onTap:(String) -> Void = {_ in }
    var emojis:[String] = ["🐶","🤔️","😋"]
    @State var animateEmoji:[Bool] = Array(repeating: false, count: 3)
    @State var animateView: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(emojis.indices, id: \.self) { index in
                Text(emojis[index])
                    .font(.system(size: 25))
                    .scaleEffect(animateEmoji[index] ? 1 : 0.01)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeInOut.delay(Double(index) * 0.1)) {
                                animateEmoji[index] = true
                            }
                        }
                    }
                    .onTapGesture {
                        onTap(emojis[index])
                    }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(.white)
                .mask {
                    Capsule()
                        .scaleEffect(animateView ? 1 : 0, anchor: .leading)
                }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                animateView = true
            }
        }
        .onChange(of: hideView) { newValue in
            if !newValue {
                withAnimation(.easeInOut(duration: 0.2).delay(0.15)) {
                    animateView = false
                }
                
                for index in emojis.indices {
                    withAnimation(.easeInOut) {
                        animateEmoji[index] = false
                    }
                }
                
            }
        }
    }
}


struct BoundsPreferences: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
    }
}
