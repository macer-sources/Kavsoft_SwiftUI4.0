//
//  ContentView.swift
//  A_34_Responsive UI Design
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ResponsiveView { props in
            Home(props: props)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
