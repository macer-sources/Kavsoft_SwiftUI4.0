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
                CustomFilteringDataView(displayPendingTask: true, filterDate: filterDate) { task in
                    TaskView(task: task)
                }
            } label: {
                Text("Pending Tasks")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            
            DisclosureGroup(isExpanded: $showCompletedTasks) {
                
                CustomFilteringDataView(displayPendingTask: false, filterDate: filterDate) { task in
                    TaskView(task: task)
                }
                
            } label: {
                Text("Completed Tasks")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        
                        Text("New Task")
                    }
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct TaskView: View {
    var task: Task
    var body: some View {
        EmptyView()
    }
}
