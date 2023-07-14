//
//  A_55_Multi_Window__Mac_App.swift
//  A_55_Multi-Window (Mac)
//
//  Created by Kan Tao on 2023/7/14.
//

import SwiftUI

@main
struct A_55_Multi_Window__Mac_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        // MARK: - multi-Tab Window Group
        WindowGroup(id: "New Tab", for: Tab.self) { $tab in
            NewTabView(tab:tab, isRootView: false)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
