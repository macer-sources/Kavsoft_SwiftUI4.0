//
//  CustomCarousel.swift
//  A_24_Animated Carousel
//
//  Created by Kan Tao on 2023/6/27.
//

import SwiftUI

struct CustomCarousel<Content: View, Item, ID>: View where Item: RandomAccessCollection, ID: Hashable, ID: Equatable {
    
    
    var id: KeyPath<Item.Element, ID>
    var content: (Item.Element, CGSize) -> Content
    
    
    init(index: Binding<Int>,items: Item, spacing: CGFloat = 30,cardPadding: CGFloat = 80,id: KeyPath<Item.Element,ID>, @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content) {
        self.id = id
        self.content = content
        self._index = index
        self.spacing = spacing
        self.cardPadding = cardPadding
        self.items = items
    }
    
    
    
    //MARK: View properties
    var spacing : CGFloat
    var cardPadding: CGFloat
    var items: Item
    @Binding var index: Int
    
    // MARK: Gesture Propreties
    
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            // MARK: reduced after applying card spacing & padding
            let cardWidth = size.width - (cardPadding - spacing)
            
            LazyHStack(spacing: spacing) {
                ForEach(items, id: id) { movie in
                    content(movie, CGSize(width: cardWidth, height: size.height))
                        .frame(width: cardWidth, height: size.height)
                }
            }
            .padding(.horizontal, spacing)
            
        }
        .padding(.top, 60)
    }
}

struct CustomCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
