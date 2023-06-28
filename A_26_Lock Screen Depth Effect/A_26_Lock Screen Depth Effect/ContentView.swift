//
//  ContentView.swift
//  A_26_Lock Screen Depth Effect
//
//  Created by Kan Tao on 2023/6/28.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = LockScreenViewModel()
    
    var body: some View {
        CustomColorFinderView(content: {
            Home()
        }, onLoad: { view in 
            viewModel.view = view
        })
        // Since home is EdgeIgnored
        // we need to ignore it for uikit translate view
        .overlay(alignment: .top,content: {
            TimeView()
                .environmentObject(viewModel)
                .opacity(viewModel.placeTextAbove ? 1 : 0)
        })
        .ignoresSafeArea()
        .environmentObject(viewModel)
        .gesture(
            MagnificationGesture(minimumScaleDelta: 0.01)
                .onChanged({ value in
                    viewModel.scale = value + viewModel.lastScale
                    viewModel.verifyScreenColor()
                })
                .onEnded({ value in
                    if viewModel.scale < 1 {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            viewModel.scale = 1
                        }
                    }
                    // excluding the main scale 1
                    viewModel.lastScale = viewModel.scale - 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        viewModel.verifyScreenColor()
                    }
                })
        )
        .onChange(of: viewModel.onLoad) { newValue in
            // what if the image is already above intially
            if newValue {
                viewModel.verifyScreenColor()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
