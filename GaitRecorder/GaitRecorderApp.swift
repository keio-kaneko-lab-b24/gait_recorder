//
//  GaitRecorderApp.swift
//  GaitRecorder
//
//  Created by Tatsuya Mizuguchi on 2023/03/29.
//

import SwiftUI

@main
struct GaitRecorderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
