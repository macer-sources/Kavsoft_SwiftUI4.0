//
//  ContentView.swift
//  A_17_App Walkthrough Intro Animations
//
//  Created by Kan Tao on 2023/7/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
                       .toolbar(.hidden, for: .navigationBar)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
