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
                    TaskView(task: task, isPendintTask: true)
                }
            } label: {
                Text("Pending Tasks")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            
            DisclosureGroup(isExpanded: $showCompletedTasks) {
                
                CustomFilteringDataView(displayPendingTask: false, filterDate: filterDate) { task in
                    TaskView(task: task, isPendintTask: false)
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
                    do {
                        let task = Task.init(context: env.managedObjectContext)
                        task.id = .init()
                        task.date = filterDate
                        task.title = ""
                        task.isCompleted = false
                        try env.managedObjectContext.save()
                        showPendingTasks = true
                        
                    }catch {
                        debugPrint(error.localizedDescription)
                    }
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
    @ObservedObject var task: Task
    var isPendintTask: Bool
    
    @Environment(\.self) private var env
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                task.isCompleted.toggle()
                save()

            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Task Title", text: .init(get: {
                    return task.title ?? ""
                }, set: { value in
                    task.title = value
                }))
                .focused($showKeyboard)
                .onSubmit {
                    if (task.title ?? "").isEmpty {
                        // remove empty task
                        env.managedObjectContext.delete(task)
                    }
                    
                    save()
                }
                
                Text((task.date ?? .init()).formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .foregroundColor(.gray)
                    .overlay {
                        
                        DatePicker(selection: .init(get: {
                            return task.date ?? .init()
                        }, set: { date in
                            task.date = date
                            // saving date when ever is's updated
                            save()
                        }), displayedComponents: [.hourAndMinute]) {
                            
                        }
                        .labelsHidden()
                        .blendMode(.destinationOver)
                    }
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .onAppear {
            if (task.title ?? "" ).isEmpty {
                showKeyboard = true
            }
        }
        // verifiying content when user leave the app
        .onChange(of: env.scenePhase) { newValue in
            if newValue != .active {
                if (task.title ?? "").isEmpty {
                    // remove empty task
                    env.managedObjectContext.delete(task)
                }
                
                save()
            }
        }
        // 右滑事件
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                env.managedObjectContext.delete(task)
                save()
            } label: {
                Image(systemName: "trash.fill")
            }

        }
    }
    
    
    // context saving method
    func save() {
        do {
            try env.managedObjectContext.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func removeEmptyTask () {
        if (task.title ?? "").isEmpty {
            // remove empty task
            env.managedObjectContext.delete(task)
        }
        
    }
}
