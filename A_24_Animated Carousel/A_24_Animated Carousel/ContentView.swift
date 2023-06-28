//
//  ContentView.swift
//  A_24_Animated Carousel
//
//  Created by Kan Tao on 2023/6/27.
//

import SwiftUI

struct ContentView: View {
    
    
    @State var current:Tab = .home
    @Namespace var animation
    
    
    // MARK: Carousel properties
    @State var currentIndex: Int = 0
    var body: some View {
        VStack(spacing: 15) {
           HeaderView()
            
            SearchView()
            
            (
                Text("Featured")
                    .fontWeight(.semibold)
                +
                Text(" Movies")
            )
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 15)
            .foregroundColor(.white)
            
            // Custom Carousel
            CustomCarousel(index: $currentIndex, items: sample_datas,cardPadding: 150 ,id: \.id) { movie,cardsize in
                // MARK: CUstom Cell View
                
                Image(movie.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cardsize.width, height: cardsize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, -15)
            .padding(.vertical)
            
            TabBar()
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            GeometryReader { proxy in
                ZStack {
                    let size = proxy.size
                    TabView(selection: $currentIndex) {
                        ForEach(sample_datas.indices, id: \.self) { index in
                            Image(sample_datas[index].artwork)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipped()
                                .tag(index)
                            
                        }
                    }
                    
                    .frame(width: size.width, height: size.height)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentIndex)
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    LinearGradient.init(colors: [.clear,Color("bg_top"),Color("bg_bottom")], startPoint: .top, endPoint: .bottom)
                    
                }
            }
            .ignoresSafeArea()
        }
    }
    
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            VStack(alignment: .leading,spacing: 6) {
                (Text("Hello").fontWeight(.semibold) + Text(" iJustine"))
                    .font(.title2)
                    .foregroundColor(.white)
                Text("Book your favourite movie")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image("avator_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
        }
    }
    
    
    @ViewBuilder
    func SearchView() -> some View {
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .foregroundColor(.gray)
            
            TextField("Search", text: .constant(""))
                .foregroundColor(.gray)
                .padding(.vertical, 10)
            
            Image(systemName: "mic.fill")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background {
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.white.opacity(0.12))
        }
        .padding(.top, 20)
    }
    
    
    
    @ViewBuilder
    func TabBar() -> some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                VStack(spacing: -2) {
                    Text(tab.rawValue)
                        .foregroundColor(current == tab ?.white : .gray.opacity(0.5))
                        .font(.callout)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                current = tab
                            }
                        }
                    
                    if current == tab {
                        Circle()
                            .fill(.white)
                            .frame(width: 5, height: 5)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom, 10)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
