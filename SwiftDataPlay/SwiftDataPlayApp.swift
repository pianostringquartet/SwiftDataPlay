//
//  SwiftDataPlayApp.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/1/23.
//

import SwiftUI
import SwiftData

func makeContainer() -> ModelContainer {
    
    // must register the transformer before we create the Container
    ValueTransformer.setValueTransformer(
        PortValueTransformer(),
        forName: NSValueTransformerName("PortValueTransformer"))

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
}

@main
struct SwiftDataPlayApp: App {


    init() {
        self.sharedModelContainer = makeContainer()
    }
    
    var sharedModelContainer: ModelContainer

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
