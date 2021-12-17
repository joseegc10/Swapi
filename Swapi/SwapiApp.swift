//
//  SwapiApp.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI

@main
struct SwapiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
