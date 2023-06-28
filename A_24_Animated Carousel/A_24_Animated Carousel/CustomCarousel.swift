//
//  CustomCarousel.swift
//  A_24_Animated Carousel
//
//  Created by Kan Tao on 2023/6/27.
//

import SwiftUI

struct CustomCarousel<Content: View, Item, ID>: View where Item: RandomAccessCollection, ID: Hashable, Item.Element: Equatable {
    
    
    var id: KeyPath<Item.Element, ID>
    var content: (Item.Element, CGSize) -> Content
    
    
    init(index: Binding<Int>,items: Item, spacing: CGFloat = 30,cardPadding: CGFloat = 80,id: KeyPath<Item.Element,ID>, @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content) {
        self._index = index
        self.items = items
        self.spacing = spacing
        self.cardPadding = cardPadding
        self.id = id
        self.content = content
    }
    
    
    
    //MARK: View properties
    var spacing : CGFloat
    var cardPadding: CGFloat
    var items: Item
    @Binding var index: Int {
        didSet {
            debugPrint("=====\(index)")
        }
    }
    
    // MARK: Gesture Propreties
    @GestureState var translation: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    
    @State var currentIndex: Int = 0
    
    // MARK: Rotation
    @State var rotation: Double = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            // MARK: reduced after applying card spacing & padding
            let cardWidth = size.width - (cardPadding - spacing)
            
            LazyHStack(spacing: spacing) {
                ForEach(items, id: id) { movie in
                    // since we already applied spacing
                    // and again we're adding it to frame
                    // so simply removing to spacing
                    let index = indexOf(item: movie)
                    content(movie, CGSize(width: size.width - cardPadding, height: size.height))
                        .rotationEffect(.init(degrees: Double(index) * 5), anchor: .bottom)
                        .rotationEffect(.init(degrees: rotation), anchor: .bottom)
                    // MARK: Apply after rotation, thus you will get smooth effect
                        .offset(y: offsetY(index: index, cardWidth: cardWidth))
                        .frame(width: size.width - cardPadding, height: size.height)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: limitScroll())
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($translation, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onChanged({
                        onChanged(value: $0, cardWidth: cardWidth)
                    })
                    .onEnded({
                        onEnd(value: $0, cardWidth: cardWidth)
                    })
            )
            
        }
        .padding(.top, 60)
        .onAppear {
            let extraSpace = (cardPadding / 2) - spacing
            offset = extraSpace
            lastStoredOffset = extraSpace
        }
        .animation(.easeInOut, value: translation == 0)
    }
    
    // MARK: Moving current item up
    func offsetY(index: Int, cardWidth: CGFloat) -> CGFloat {
        // MARK: we're coverting the current translation, not whole offset
        // that's why created @GestureState to hold the current translation data
        
        // coverting translation to -60...60
        let progress = ((translation < 0 ? translation : -translation) / cardWidth) * 60
        let yoffset = -progress < 60 ? progress : -(progress + 120)
        
        // MARK: checking previous , next and in-between offset
        let previous = (index - 1) == self.index ? (translation < 0 ? yoffset : -yoffset) : 0
        let next = (index + 1) == self.index ? (translation < 0 ? -yoffset : yoffset) : 0
        
        let in_between = (index - 1) == self.index ?  previous : next
        return index == self.index ? -60 - yoffset : in_between
    }
    
    
    
    // MARK: Item Index
    func indexOf(item: Item.Element) -> Int {
        let array = Array(items)
        if let index = array.firstIndex(where: {$0 == item}) {
            return index
        }
        return 0
    }
    
    
    // MARK: Limiting scroll on first and last items
    func limitScroll() -> CGFloat {
        let extraSpace = (cardPadding / 2) - spacing
        if index == 0 && offset > extraSpace {
            return extraSpace +  offset / 4
        }else if index == items.count - 1 && translation < 0 {
            return offset - (translation / 2)
        }else {
            return offset
        }
    }
    
    func onChanged(value: DragGesture.Value, cardWidth: CGFloat) {
        let translationX = value.translation.width
        offset = translationX + lastStoredOffset
        
        // MARK: Calculating Rotation
        let progress = offset / cardWidth
        rotation = progress * 5
        
    }
    
    func onEnd(value: DragGesture.Value, cardWidth: CGFloat) {
        // MARK: finding current index
        var _index = (offset / cardWidth).rounded()
        _index = max(-CGFloat(items.count - 1), _index)
        _index = min(_index, 0)
        
        
        currentIndex = Int(_index)
        // MARK: Updating Index
        // Note Since We're moving on right side
        // so all data will be navigative
        index = -currentIndex
        withAnimation(.easeInOut(duration: 0.25)) {
            // MARK: Removing extra space
            // why /2 ? ---> because we need both sides need to be visible
            let extraSpace = (cardPadding / 2) - spacing
            offset = (cardWidth * _index) + extraSpace
            
            // MARK: Calculating Rotation
            let progress = offset / cardWidth
            rotation = (progress * 5).rounded() - 1
        }
        lastStoredOffset = offset
    }
    
}

struct CustomCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
