//
//  ContentView.swift
//  A_22_Gesture Based Expansion Animations
//
//  Created by Kan Tao on 2023/6/26.
//

import SwiftUI

struct ContentView: View {
    @State var tools:[Tool] = [
        .init(icon: "scribble.variable", name: "Scribble", color: .purple),
        .init(icon: "lasso", name: "Lasso", color: .green),
        .init(icon: "plus.bubble", name: "Comment", color: .blue),
        .init(icon: "bubbles.and.sparkles.fill", name: "Enhance", color: .orange),
        .init(icon: "paintbrush.pointed.fill", name: "Picker", color: .pink),
        .init(icon: "rotate.3d", name: "Rotate", color: .indigo),
        .init(icon: "gear.badge.questionmark", name: "Settings", color: .yellow)
    ]
    
    
    
    //MARK: Animation Properties
    @State var activitTool: Tool?
    @State var startedToolPosition: CGRect = .zero
    
    
    var body: some View {
        NavigationStack {
            VStack {
               Tool()
            }
            .navigationTitle("Tool Animation")
        }
    }
}

extension ContentView {
    @ViewBuilder
    func Tool() -> some View {
        VStack {
            
            VStack(alignment: .leading,spacing: 12 ) {
                ForEach($tools) { $tool in
                    ToolView(tool: $tool)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        .white.shadow(
                            .drop(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                        )
                        .shadow(.drop(color: .black.opacity(0.05), radius: 5, x: -5, y: -5))
                    )
                // MARK: 控制背景大小，避免将文字也包含进来
                // image size = 45， padding = 20
                // total = 65
                    .frame(width: 65)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .coordinateSpace(name: "AREA")
            .gesture(DragGesture(minimumDistance: 0).onChanged({ value in
                // MARK: Current Drag Location
                
                guard let firstTool = tools.first else {return}
                if startedToolPosition == .zero {
                    startedToolPosition = firstTool.toolPostion
                }
                let location = CGPoint(x: startedToolPosition.minX, y: value.location.y)
                // Checking if the location lies on any of the tools
                // with the help of contains property
                if let index = tools.firstIndex(where: { tool in
                    tool.toolPostion.contains(location)
                }), activitTool?.id != tools[index].id {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                        activitTool = tools[index]
                    }
                }
                
            }).onEnded({ _ in
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                    activitTool = nil
                    startedToolPosition = .zero
                }
            }))
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    func ToolView(tool: Binding<Tool>) -> some View {
        HStack(spacing: 5) {
            Image(systemName: tool.wrappedValue.icon)
                .font(.title2)
                .frame(width: 45, height: 45)
                .padding(.leading, activitTool?.id == tool.id ? 5 : 0)
                // MARK: Getting Image Location Using Geometry Proxy And Preference Key
                .background {
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named("AREA"))
                        Color.clear
                            .preference(key: RectKey.self, value: frame)
                            .onPreferenceChange(RectKey.self) { rect in
                                tool.wrappedValue.toolPostion = rect
                            }
                    }
                    
                }
            
            if activitTool?.id == tool.id {
                Text(tool.wrappedValue.name)
                    .padding(.trailing, 15)
                    .foregroundColor(.white)
                
            }

        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(tool.wrappedValue.color.gradient)
        }
        .offset(x: activitTool?.id == tool.wrappedValue.id ? 60 : 0)
    }
    
}


struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
