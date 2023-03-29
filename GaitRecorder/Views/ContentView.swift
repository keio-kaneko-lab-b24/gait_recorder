import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(sortDescriptors: [SortDescriptor(\.unixtime, order: .reverse)])
    private var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.unixtime, order: .reverse)])
    private var steps: FetchedResults<Step>
    
    var dbManager = DBManager()
    @State var isStartButton = false
    @State var isExportButton = false
    @State var nextRecordId = 0

    var body: some View {
        VStack {
            VStack {
                Text("歩行記録").title()
                Text("左右差を検知するために左右の歩行を記録します。").explain()
            }.padding(.vertical)
            
            HStack {
                Button(action: {
                    isExportButton.toggle()
                }){
                    Text("書き出し").button()
                }.secondary()
                
                Button(action: {
                    nextRecordId = dbManager.getLastRecordId(gaits: gaits, steps: steps) + 1
                    dbManager.saveGait(
                        recordId: nextRecordId, unixtime: unixtime(),
                        context: context)
                    isStartButton.toggle()
                }){
                    Text("開始").button()
                }.primary()
            }.padding()
            
            List {
                ForEach(gaits) { gait in
                    Text("\(gaitString(gait: gait))")
                }
                .onDelete(perform: deleteItems)
            }
        }
        
        NavigationLink(
            destination: StepView(recordId: nextRecordId),
            isActive: $isStartButton
        ) {
            EmptyView()
        }
    }
    
    private func gaitString(gait: Gait) -> String {
        let time = unixtimeToDateString(unixtimeMillis: Int(gait.unixtime))
        return "\(Int(gait.record_id)): \(time)"
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
