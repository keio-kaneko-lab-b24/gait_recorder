import SwiftUI

@main
struct GaitRecorderApp: App {
    let persistentController = PersistentController()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView().environment(\.managedObjectContext, persistentController.container.viewContext)
            }
        }
    }
}
