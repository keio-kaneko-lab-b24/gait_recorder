import CoreData

struct PersistentController {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Gait")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        })
    }
}
