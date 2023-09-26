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

    var tester: some View {
        Text("love")
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        HStack {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                            
//                            if let _id = item.mood.getId {
//                                Text("_id: \(_id.id.uuidString)")
//                            } else {
//                                Text("no id...")
//                            }
//                                   
//                            
                            if let n = item.mood.getNumber {
                                Text("n: \(n)")
                            } else {
                                Text("no number")
                            }
                                   
                            
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
                            
                        
                            
//                            if let modelData = item.mlModel {
////                                Text("model bytes: \(modelData.count)")
//                                Text("had model")
//                            }
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
                
//                if let _item = items.first {
//                    if let video = _item.video {
//                        
//                        // URL.init(dataRepresentation: <#T##Data#>, relativeTo: <#T##URL?#>, isAbsolute: <#T##Bool#>)
//                                                
//                        // let player = AVPlayer(url: <#T##NSURL#>)
//                        
//                        
//                        VideoPlayer(
//                            player: AVPlayer(
//                                url:  Bundle.main.url(forResource: "video", withExtension: "mp4")!))
//                        .frame(height: 400)
//                    }
//                    
//                } // if let _item
            }
           
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(),
                               child: .init(age: 2))
            
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
