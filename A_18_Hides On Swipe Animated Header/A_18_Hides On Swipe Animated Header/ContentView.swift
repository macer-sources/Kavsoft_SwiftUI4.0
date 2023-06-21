//
//  ContentView.swift
//  A_18_Hides On Swipe Animated Header
//
//  Created by Kan Tao on 2023/6/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var headerHeight: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Thumbnails()
                .padding(.top, headerHeight)
                .offsetY { previous, current in
                    if previous > current {
                        print("Up")
                    }else {
                        print("Down")
                    }
                }
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .top) {
            HeaderView()
                .anchorPreference(key: HeaderBoundsKey.self, value: .bounds, transform: {$0})
                .overlayPreferenceValue(HeaderBoundsKey.self) { value in
                    GeometryReader { proxy in
                        if let anchor = value {
                            Color.clear
                                .onAppear {
                                    // MARK: retreiving rect using proxy
                                    headerHeight = proxy[anchor].height
                                }
                        }
                    }
                }
        }
    }
    
    
    @ViewBuilder
    func Thumbnails() -> some View {
        VStack(spacing: 20) {
            ForEach(1...6, id:\.self) { index in
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    Image("image\(index)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped() // TODO: 此处必须裁剪
                }
                .frame(height: 200)
                .padding(.horizontal)
            }
        }
    }
    
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 12) {
            VStack {
                HStack {
                    Text("YouTube")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 18) {
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.pencil.circle")
                                .font(.title2)
                        }

                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, 10)
                
                Divider()
                    .padding(.horizontal, -15)
            }
            .padding([.horizontal, .top], 15)
            
            TagView()
                .padding(.bottom, 10)
            
        }
        .background {
            Color.white.ignoresSafeArea()
        }
    }
    
    
    @ViewBuilder
    func TagView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(["All","Justine","Kavsoft","Apple","SwiftUI","Programming","Technology"], id: \.self) { tag in
                    Button {
                        
                    } label: {
                        Text(tag)
                            .font(.callout)
                            .foregroundColor(.black)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background {
                                Capsule()
                                    .fill(.black.opacity(0.08))
                            }
                    }

                }
            }
            .padding(.horizontal, 15)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
