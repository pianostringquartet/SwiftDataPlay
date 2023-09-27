//
//  ContentView.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/1/23.
//

import SwiftUI
import SwiftData
import AVKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    
//    var items: [Item] {
////        let k = try? modelContext.fetch(FetchDescriptor<Item>())
////        return k ?? []
//        modelContext.items
//    }

    /*
     // Nodes visible at this traversal level
     private var nodes: NodeEntities {
         document.nodes!.filter { $0.parentGroupNodeId == groupNodeFocused?.asNodeId }
     }
     */
    
    var body: some View {
        _body.onAppear {
//            modelContext.container.deleteAllData()
            print("modelContext.container.configurations.first!.url: \(modelContext.container.configurations.first!.url)")
        }
    }
        
    var _body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        HStack {
                            Text(item.timestamp, 
//                                 format: Date.FormatStyle(date: .numeric, time: .standard)
                                 format: Date.FormatStyle(date: .abbreviated)
                            )

                            //                            Text("test: \(item.mood.display)")
                            
//                            Text("dog \(item.dogName)")
//                            Text("value: \(item.values.first!.display)")
                            
                            Text("value: \(item.value.display)")
                     
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            VStack {
                Text("Select an item")
            }
           
        }
    }

    private func addItem() {
        withAnimation {
            _addItems([
                .anchoring(.bottomCenter),
                .plane(.horizontal),
                .networkRequestType(.post),
                
    //            .position(.zero)
//                .position(CGSize(width: 50, height: 50)),
//                .point3D(.nonZero),
//                .point4D(.nonZero)
            ])
        
        }
    }
    
    private func _addItems(_ values: PortValues) {
        for value in values {
            print("_addItems: value.display: \(value.display)")
            let newItem = Item(timestamp: Date(),
                               value)
//                               [value])
            
            print("_addItems: newItem.value.display: \(newItem.value.display)")
            modelContext.insert(newItem)
        }
        
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            try? modelContext
                .fetch(FetchDescriptor<Item>())
                .forEach { (item: Item) in
                    modelContext.delete(item)
                }
            
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
