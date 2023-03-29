import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\.unixtime, order: .reverse)])
    private var records: FetchedResults<GaitRecord>

    var body: some View {
        NavigationView {
            List {
                ForEach(records) { record in
                    Text("\(recordString(record: record))")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        addAction(actionId: 1)
                    }) {
                        Label("Start", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addAction(actionId: Int) {
        withAnimation {
            let record = GaitRecord(context: viewContext)
            record.unixtime = Int64(unixtime())
            record.action = Int32(actionId)
            try? viewContext.save()
        }
    }
    
    private func recordString(record: GaitRecord) -> String {
        let unixtime = unixtimeToDateString(unixtimeMillis: Int(record.unixtime))
        var action = ""
        if (Int(record.action) == 1) { action = "START" }
        else if (Int(record.action) == 2) { action = "LEFT" }
        else if (Int(record.action) == 3) { action = "RIGHT" }
        else if (Int(record.action) == 4) { action = "END" }
        return "\(action) \(unixtime)"
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { records[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
