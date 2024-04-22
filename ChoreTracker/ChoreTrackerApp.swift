//
//  ChoreTrackerApp.swift
//  ChoreTracker
//
//  Created by Nathan Fuller on 3/17/24.
//

import SwiftUI
import SwiftData

@main
struct ChoreTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Chore.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ChoreListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
