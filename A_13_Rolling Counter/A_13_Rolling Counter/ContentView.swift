//
//  ContentView.swift
//  A_13_Rolling Counter
//
//  Created by Kan Tao on 2023/6/20.
//

import SwiftUI

struct ContentView: View {
    @State private var value: Int = 111
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                RollingText(font: .system(size: 55), weight: .black,value: $value)
                
                Button {
                    value = .random(in: 200...3000)
                } label: {
                    Text("Change Value")
                }

            }
            .padding()
            .navigationTitle("Rolling Counter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
