//
//  SwiftDataPlayApp.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/1/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataPlayApp: App {
    var sharedModelContainer: ModelContainer = {
        
        // 'top level' data types
        let schema = Schema([
            Item.self,
        ])
        
        
        
        // "The only top level item is Item.self"
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onTapGesture {
//                    sharedModelContainer.configurations.first?.
                    sharedModelContainer.configurations.first?.
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
