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
    
    var body: some View {
        NavigationStack {
            ScrollView(content: {
                VStack(spacing: 12) {
                    ForEach(chat) { chat in
                        ChatView(message: chat)
                        // 使用锚点首选项读取视图锚点值（bounds）
                            .anchorPreference(key: BoundsPreferences.self, value: .bounds, transform: { anchor in
                                return [chat.id : anchor]
                            })
                            .padding(chat.isReply ? .leading : .trailing, 60)
                            .onLongPressGesture {
                                withAnimation {
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
            if let _ = hightlightChat {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
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
                    
                    ChatView(message: hightlightChat)
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
    func ChatView(message: Message) -> some View {
        Text(message.message)
            .padding(15)
            .background(message.isReply ? Color.gray.opacity(0.2) : Color.blue)
            .foregroundColor(message.isReply ? .black :  .white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




struct BoundsPreferences: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
    }
}
