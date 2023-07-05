//
//  Home.swift
//  A_34_Responsive UI Design
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI

struct Home: View {
    
    @State var currentTab: String = "Home"
    @Namespace var animation
    
    var props: Properties
    var body: some View {
        HStack(spacing: 0) {
            
            SideBar()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            Color.black
                .opacity(0.04)
                .ignoresSafeArea()
        }
    }
}


// MARK: Side bar
extension Home {
    @ViewBuilder
    func SideBar() -> some View {
        // MARK: Tabs
        let tabs:[String] = [
            "Home",
            "Category",
            "Document",
            "Chart",
            "Bag",
            "Graph",
            "Notification",
            "Setting"
        ]
        
        VStack(spacing: 10) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
                .padding(.bottom, 10)
            ForEach(tabs, id: \.self) { tab in
                VStack(spacing: 8) {
                    Image(tab)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    
                    Text(tab)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(currentTab == tab ?  .orange : .gray)
                .padding(.vertical, 13)
                .frame(width: 65)
                .background {
                    if currentTab == tab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.orange.opacity(0.1))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        currentTab = tab
                    }
                }
            }
            
            
            // MARK: Profile icon
            Button {
                
            } label: {
                VStack {
                    Image("avator_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Text("Profile")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }

            
        }
        .padding(.vertical)
        .padding(.top, 20)
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: 100)
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
