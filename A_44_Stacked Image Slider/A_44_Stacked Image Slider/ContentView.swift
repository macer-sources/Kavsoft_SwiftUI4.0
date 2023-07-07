//
//  ContentView.swift
//  A_44_Stacked Image Slider
//
//  Created by Kan Tao on 2023/7/7.
//

import SwiftUI

struct ContentView: View {
    @State var messages:[Message] = []
    var body: some View {
        VStack {
            SwipeCarousel(items: messages, id: \.id) { item, size in
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(width: 220, height: 300)
        }
        .onAppear {
            // MARK: Createing sample messages
            for index in 1...8 {
                messages.append(Message.init(image: "pexels_\(index)"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: Custom View
struct SwipeCarousel<Content: View, ID, Item>: View where Item:RandomAccessCollection, Item.Element: Equatable,Item.Element: Identifiable, ID: Hashable {
    
    var id: KeyPath<Item.Element, ID>
    var items: Item
    
    // MARK: Creating a custom view like foreach
    var content:(Item.Element, CGSize) -> Content
    
    var trailingCards:Int = 3
    
    init(items:Item, id: KeyPath<Item.Element, ID>,trailingCards: Int = 3, @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content) {
        self.id = id
        self.items = items
        self.content = content
        self.trailingCards = trailingCards
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                ForEach(items) { item in
                    content(item, size)
                        .shadow(color: .black.opacity(0.25), radius: 5, x: 5, y: 5)
                        .scaleEffect(scaleFor(item: item))
                        .offset(x: offsetFor(item: item))
                        .rotationEffect(.init(degrees: rotationFor(item: item)), anchor: .topTrailing)
                        .zIndex(zIndex(item: item))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    
    
    // MARK: Applying offsets, scaling and rotation for each based on index
    func offsetFor(item: Item.Element) -> CGFloat {
        let index = indexOf(item: item)
        if index > trailingCards {
            return 20 * CGFloat(trailingCards)
        }
        return CGFloat(index) * 20
    }
    func scaleFor(item: Item.Element) -> CGFloat {
        let index = indexOf(item: item)
        if index > trailingCards {
            return 1 - (CGFloat(trailingCards) / 20)
        }
        // MARK: For each card i'm going to decrease 0.05 scaling (it's your own custom value)
        return 1 - (CGFloat(index) / 20)
    }
    func rotationFor(item: Item.Element) -> CGFloat {
        let index = indexOf(item: item)
        if index > trailingCards {
            return CGFloat(trailingCards) * 3
        }
        // MARK: For each card i'm going to rotate 0.3deg scaling (it's your own custom value)
        return CGFloat(index) * 3
    }
    
    
    
    
    // MARK: ZIndex value for each card
    func zIndex(item: Item.Element) -> Double {
        let index = indexOf(item: item)
        let totalCount = items.count
        
        return Double(totalCount - index)
    }
    
    // MARK: Index For Each Card
    func indexOf(item: Item.Element) -> Int {
        let _items = Array(items)
        if let index = _items.firstIndex(of: item) {
            return index
        }
        return 0
    }
    
}

