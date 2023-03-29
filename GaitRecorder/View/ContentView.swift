import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(sortDescriptors: [SortDescriptor(\.start_unixtime, order: .reverse)])
    private var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.unixtime, order: .reverse)])
    private var steps: FetchedResults<Step>
    
    var dbManager = DBManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(gaits) { gait in
                    Text("\(gaitString(gait: gait))")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        addAction()
                    }) {
                        Label("Start", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addAction() {
        let nextRecordId = dbManager.getLastRecordId(gaits: gaits, steps: steps) + 1
        dbManager.saveStep(
            recordId: nextRecordId, actionId: 1, unixtime: unixtime(),
            context: context)
        dbManager.saveGait(
            recordId: nextRecordId, startUnixtime: unixtime(), endUnixtime: unixtime() + 10000,
            context: context)
    }
    
    private func gaitString(gait: Gait) -> String {
        let start = unixtimeToDateString(unixtimeMillis: Int(gait.start_unixtime))
        let end = unixtimeToTimeString(unixtimeMillis: Int(gait.start_unixtime))
        return "\(Int(gait.record_id)): \(start) ~ \(end)"
    }

    // RecordIdに紐づくGaitとStepを削除する。
    private func deleteItems(offsets: IndexSet) {
        offsets.forEach { index in
            let record_id = Int(gaits[index].record_id)
            context.performAndWait {
                dbManager.deleteGait(gaits: gaits, recordId: record_id, context: context)
                dbManager.deleteStep(steps: steps, recordId: record_id, context: context)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
