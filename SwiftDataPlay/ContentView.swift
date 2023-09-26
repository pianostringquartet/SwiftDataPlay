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
//        let k = try? modelContext.fetch(FetchDescriptor<Item>())
//        return k ?? []
//    }

    /*
     // Nodes visible at this traversal level
     private var nodes: NodeEntities {
         document.nodes!.filter { $0.parentGroupNodeId == groupNodeFocused?.asNodeId }
     }
     */
        
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        HStack {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))

                            //                            Text("test: \(item.mood.display)")
                            
                            Text("dog \(item.dogName)")
                            
                            if let imageData = item.image,
                               let image = UIImage(data: imageData) {
                                Image.init(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.5)
                                    .frame(width: 30, height: 30)
                            }
                            
                            if let videoData = item.video {
                                Text("video bytes: \(videoData.count)")
                            }
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
            let newItem = Item(timestamp: Date())
            print("addItem: newItem: \(newItem)")
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
