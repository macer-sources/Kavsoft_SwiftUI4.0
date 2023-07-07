//
//  Spotlight.swift
//  A_17_App Walkthrough Intro Animations
//
//  Created by Kan Tao on 2023/7/7.
//

import SwiftUI



enum SpotlightShape {
    case circle
    case rectangle
    case rounded
}

extension View {
    // MARK: NEW modifier for adding elements for spotlight preview
    @ViewBuilder
    func addSpotlight(_ id: Int, shape: SpotlightShape = .rectangle, roundedRadius: CGFloat = 0, text: String = "") -> some View {
        self
        // MARK: Using anchor preferences for retreiving view's bounds region
            .anchorPreference(key: BoundKey.self, value: .bounds) { anchor in
                [id: BoundKeyProperties(shape: shape, anchor: anchor, text: text, radius: roundedRadius)]
            }
        
    }
    
    // MARK: Modifier to displaying spotlight content
    // NOTE: Add to root View
    @ViewBuilder
    func addSpotlightOverlay(show: Binding<Bool>, currentSpot: Binding<Int>) -> some View {
        self.overlayPreferenceValue(BoundKey.self) { values in
            GeometryReader { proxy in
                if let proference = values.first(where: { item in
                    item.key == currentSpot.wrappedValue
                }) {
                    let screenSize = proxy.size
                    let anchor = proxy[proference.value.anchor]
                    
                    // MARK: Spotlight View
                    SpotlightHelperView(screenSize: screenSize, rect: anchor, show: show, currentSpot: currentSpot, properties: proference.value) {
                        if currentSpot.wrappedValue <= (values.count) {
                            currentSpot.wrappedValue += 1
                        }else {
                            show.wrappedValue = false
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .animation(.easeInOut, value: show.wrappedValue)
            .animation(.easeInOut, value: currentSpot.wrappedValue)
        }
    }
    
    
    // MARK: Helper View
    @ViewBuilder
    func SpotlightHelperView(screenSize: CGSize, rect: CGRect, show:Binding<Bool>, currentSpot: Binding<Int>,properties: BoundKeyProperties, onTap:@escaping () -> Void) -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .opacity(show.wrappedValue ? 1 : 0)
            // MARK: Spitlight Text
            .overlay(alignment: .topLeading) {
                Text(properties.text)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                // MARK: Extracting Text Size
                    .opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let textSize = proxy.size
                            
                            Text(properties.text)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            //MARK: Dynamic text aligment
                            // MARK: Horizontal Checking
                                .offset(x: (rect.minX + textSize .width) >
                                        (screenSize.width - 15) ? -((rect.minX + textSize.width) - (screenSize.width - 15) )
                                        : 0)
                                .offset(y: (rect.maxY + textSize.height) > (screenSize.height - 50) ? -(textSize.height + (rect.maxY - rect.minY) + 30) : 30)
                                
                        }
                        .offset(x: rect.minX, y: rect.maxY)
                    }
            }
        // TODO: 原理，反转mask (reverse masking the current spot)
        // by doing this, the currently spotlighted view will be looking like highlighted
            .mask {
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        let radius = properties.shape == .circle ? (rect.width / 2) : (properties.shape == .rectangle ? 0 : properties.radius)
                        RoundedRectangle(cornerRadius: radius)
                            .frame(width: rect.width, height: rect.height)
                            .offset(x: rect.minX, y: rect.minY)
                            .blendMode(.destinationOut)
                    }
            }
            .onTapGesture {
                // MARK: Updating Spotlight Spot
                onTap()
            }
    }
    
    
}


// MARK: Bounds Preferences Key Properties
struct BoundKeyProperties {
    var shape: SpotlightShape
    var anchor: Anchor<CGRect>
    var text: String = ""
    var radius: CGFloat = 0
}

struct BoundKey: PreferenceKey {
    static var defaultValue: [Int: BoundKeyProperties] = [:]
    static func reduce(value: inout [Int : BoundKeyProperties], nextValue: () -> [Int : BoundKeyProperties]) {
        value.merge(nextValue()) {
            $1
        }
    }
}



struct Spotlight: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


struct Spotlight_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
