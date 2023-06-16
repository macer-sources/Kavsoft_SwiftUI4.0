//
//  A_121_Simple_TO_DO_ListApp.swift
//  A_121_Simple TO-DO List
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

@main
struct A_121_Simple_TO_DO_ListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
