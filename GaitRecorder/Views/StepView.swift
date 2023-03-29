import SwiftUI

struct StepView: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    
    var dbManager = DBManager()
    let recordId: Int
    @State var toggle: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    toggle.toggle()
                    dbManager.saveStep(
                        recordId: recordId, actionId: 1, unixtime: unixtime(),
                        context: context)
                }) {
                    Text("←左").circle(enable: !toggle)
                }.disabled(toggle)
                
                Spacer()
                
                Button(action: {
                    toggle.toggle()
                    dbManager.saveStep(
                        recordId: recordId, actionId: 2, unixtime: unixtime(),
                        context: context)
                }) {
                    Text("右→").circle(enable: toggle)
                }.disabled(!toggle)
                
                Spacer()
            }.padding(.vertical)
            
            Button(
                action: {
                    dismiss()
                }, label: {
                    Text("終了").button()
                }
            ).secondary().padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(recordId: 1)
    }
}
