//
//  ContentView.swift
//  A_121_Simple TO-DO List
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI
import CoreData

struct ContentView: View {
   
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("TO-DO")
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
