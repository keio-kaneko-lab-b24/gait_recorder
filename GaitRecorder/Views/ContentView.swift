import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(sortDescriptors: [SortDescriptor(\.unixtime, order: .reverse)])
    private var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.unixtime, order: .reverse)])
    private var steps: FetchedResults<Step>
    
    var dbManager = DBManager()
    let fileManager = UserFileManager()
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
                    toCsv()
                }){
                    Text("書き出し").button()
                }
                .secondary()
                .alert("歩行記録を書き出しました", isPresented: $isExportButton) {
                    Button("OK") { /* Do Nothing */}
                } message: {
                    Text("「ファイルアプリ」>「このiPhone内」>「歩行記録アプリ」からファイルを確認できます。")
                }
                
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
            // contextを明示的に渡す必要あり
            // https://reasonable-code.com/swiftui-coredata-subview-error/
            destination: StepView(recordId: nextRecordId)
                .environment(\.managedObjectContext, self.context),
            isActive: $isStartButton
        ) {
            EmptyView()
        }
    }
    
    // gaitを表示形式に変換する
    private func gaitString(gait: Gait) -> String {
        let time = unixtimeToDateString(unixtimeMillis: Int(gait.unixtime))
        return "\(Int(gait.record_id)): \(time)"
    }

    // RecordIdに紐づくGaitとStepを削除する
    private func deleteItems(offsets: IndexSet) {
        offsets.forEach { index in
            let record_id = Int(gaits[index].record_id)
            context.performAndWait {
                dbManager.deleteGait(gaits: gaits, recordId: record_id, context: context)
                dbManager.deleteStep(steps: steps, recordId: record_id, context: context)
            }
        }
    }
    
    func toCsv() {
        let gaitText = dbManager.gaitToCsv(gaits: gaits)
        fileManager.saveFile(data: gaitText, fileName: "gait.csv")
        let stepText = dbManager.stepToCsv(steps: steps)
        fileManager.saveFile(data: stepText, fileName: "step.csv")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
