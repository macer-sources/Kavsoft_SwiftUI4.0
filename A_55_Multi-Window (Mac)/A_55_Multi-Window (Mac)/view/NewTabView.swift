//
//  NewTabView.swift
//  A_55_Multi-Window (Mac)
//
//  Created by Kan Tao on 2023/7/14.
//
import SwiftUI


// Chrome UI
struct NewTabView: View {
    var tab: Tab?
    var isRootView: Bool = false
    @State private var searchText = ""
    
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                CustomButtonView(systemImage: "arrow.left") {
                    
                }.foregroundColor(.gray)
                CustomButtonView(systemImage: "arrow.right") {
                    
                }.foregroundColor(.gray)
                CustomButtonView(systemImage: "arrow.clockwise") {
                    
                }.foregroundColor(.white)
                
                SearchBar()
                
                CustomButtonView(systemImage: "star") {
                    
                }.foregroundColor(.gray)
                
                
                // Menu
                Menu {
                    Button("New Window") {
                        // adding New Window
                        // Pass you additional info here
                        let newTab = Tab()
                        openWindow(value: newTab)
                    }
                    Button("Help") {
                        
                    }
                    Button(isRootView ? "Quit" : "Close Window") {
                        if isRootView {
                            NSApplication.shared.terminate(nil)
                        }else {
                            NSApplication.shared.mainWindow?.close()
                        }
                    }
                }label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(90))
                        .frame(width: 20, height: 20)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background {
                Color("navbar")
                    .ignoresSafeArea()
            }
            
            
            ZStack {
                Color("bg").ignoresSafeArea()
            }
            
        }.frame(width: 500, height: 400)
            .preferredColorScheme(.dark)
    }
}

extension NewTabView {
    @ViewBuilder
    func CustomButtonView(systemImage: String, onTap:@escaping () -> Void) -> some View {
        Button {
            onTap()
        } label: {
            Image(systemName: systemImage)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(width: 20, height: 20)
                .contentShape(Rectangle())
        }.buttonStyle(.plain)

    }
    
    
    @ViewBuilder
    func SearchBar() -> some View {
        TextField("Search Google or type a URL", text: $searchText)
            .textFieldStyle(.plain)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background {
                Capsule()
                    .fill(.black.opacity(0.2))
            }
            .foregroundColor(.white)
    }
    
}



struct NewTabView_Previews: PreviewProvider {
    static var previews: some View {
        NewTabView()
    }
}

