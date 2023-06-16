//
//  CustomFilteringDataView.swift
//  A_121_Simple TO-DO List
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

struct CustomFilteringDataView<Content: View>: View {
    
    var content:([Task], [Task]) -> Content
    @FetchRequest
    private var result: FetchedResults<Task>
    @Binding private var filterDate: Date
    
    init(filterDate:Binding<Date>, @ViewBuilder content: @escaping([Task], [Task]) -> Content) {
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: filterDate.wrappedValue)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        
        let predicate = NSPredicate.init(format: "date >= %@ AND date <= %@", argumentArray: [startOfDay, endOfDay])
        
        _result = FetchRequest.init(entity: Task.entity(), sortDescriptors: [
            NSSortDescriptor.init(keyPath: \Task.date, ascending: false)
        ], predicate: predicate, animation: .easeInOut(duration: 0.25))
        
        self.content = content
        self._filterDate = filterDate
        
    }
    
    var body: some View {
        content(separateTaks().0, separateTaks().1)
            .onChange(of: filterDate) { newValue in
                result.nsPredicate = nil
                
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: newValue)
                let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
                let predicate = NSPredicate.init(format: "date >= %@ AND date <= %@", argumentArray: [startOfDay, endOfDay])
                
                result.nsPredicate = predicate
            }
    }
    
    func separateTaks() -> ([Task], [Task]) {
        let pendingTaks = result.filter{!$0.isCompleted}
        let completedTasks = result.filter{$0.isCompleted}
        return (pendingTaks, completedTasks)
    }
    
    
}

struct CustomFilteringDataView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
