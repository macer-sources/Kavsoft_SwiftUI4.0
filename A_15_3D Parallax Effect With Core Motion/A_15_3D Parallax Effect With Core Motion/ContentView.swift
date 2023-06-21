//
//  ContentView.swift
//  A_15_3D Parallax Effect With Core Motion
//
//  Created by Kan Tao on 2023/6/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var manager = MotionManager()
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "person")
                        .font(.title3)
                }

            }
            .foregroundColor(.white)
            .padding(.horizontal)
            
            Text("Exclusive trips just for you")
                .foregroundColor(.white)
                .padding(.top, 10)
            
            
            ParallaxCards()
                .padding(.horizontal, -15)
            
            TabBar()
        }
        .padding(15)
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(Color("bg"))
                .ignoresSafeArea()
        }
    }
}


extension ContentView {
    @ViewBuilder
    func ParallaxCards() -> some View {
        TabView(selection: $manager.currentSide) {
            ForEach(sample_datas) { place in
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZStack {
                        Image(place.bg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipped()
                        
                        Image(place.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipped()
                        
                        VStack(spacing: 10) {
                            Text("FEATURES")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text(place.name)
                                .font(.system(size: 45))
                                .foregroundColor(.white.opacity(0.6))
                                .shadow(color: .black.opacity(0.3), radius: 15, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.3), radius: 15, x: -5, y: -5)
                            
                            Button {
                                
                            } label: {
                                Text("EXPLORE")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background {
                                        ZStack {
                                            Rectangle()
                                                .fill(.black.opacity(0.15))
                                            Rectangle()
                                                .fill(.black.opacity(0.3))
                                        }
                                    }
                            }
                            .padding(.top, 15)

                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 60)
                    }
                    
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 40)
                .tag(place)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            manager.detectMotion()
        }
        .onDisappear {
            manager.stopMotionUpdates()
        }
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        HStack {
            ForEach(["house", "suit.heart","magnifyingglass"],id: \.self ) { icon in
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
