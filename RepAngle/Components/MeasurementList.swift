//
//  MeasurementList.swift
//  RepAngle
//
//  Created by Wilson Chan on 6/9/25.
//

import SwiftUI
import SwiftData

struct MeasurementList: View {
    
    // Swift Data
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor(\MeasurementItem.timestamp, order: .reverse)]) private var items: [MeasurementItem]
    
    // Close View
    @Environment(\.dismiss) private var dismiss
    
    //Edit View
    @State private var selectedItem: MeasurementItem?
    
    var body: some View {
        VStack {
            ZStack {
                Text("Measurements")
                    .font(.system(size: 24))
                    .bold()
                
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle")
                            .foregroundStyle(.gray)
                            .font(.system(size: 24))
                            .padding(10)
                    }
                }
            }
            List {
                ForEach(items) { item in
                    MeasurementListItem(measurement: item) {
                        selectedItem = item
                    }
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteItem(items[index])
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.clear)
            Button("Clear All") {
                clearAllItems()
            }
            .foregroundColor(.red)
        }
        .padding()
        .sheet(item: $selectedItem) { item in
            EditMeasurementView(item: item)
        }
    }
    
    func deleteItem(_ item: MeasurementItem) {
        context.delete(item)
    }
    
    func clearAllItems() {
        for item in items {
            context.delete(item)
        }
    }
}

#Preview {
    MeasurementList()
}
