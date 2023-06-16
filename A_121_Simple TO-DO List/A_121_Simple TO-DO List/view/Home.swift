//
//  Home.swift
//  A_121_Simple TO-DO List
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

struct Home: View {
    
    @Environment(\.self) private var env
    
    @State private var filterDate = Date()
    
    @State private var showPendingTasks = false
    @State private var showCompletedTasks = false
    
    var body: some View {
        List {
            DatePicker(selection: $filterDate, displayedComponents: [.date]) {
                
            }
            .labelsHidden()
            .datePickerStyle(.graphical)
            
            DisclosureGroup(isExpanded: $showPendingTasks) {
                
            } label: {
                Text("Pending Tasks")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            
            DisclosureGroup(isExpanded: $showCompletedTasks) {
                
            } label: {
                Text("Completed Tasks")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
