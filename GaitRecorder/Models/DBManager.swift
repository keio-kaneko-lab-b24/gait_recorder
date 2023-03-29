import SwiftUI
import CoreData

struct DBManager {
    /*
     Gaitの追加
     */
    func saveGait(
        recordId: Int, startUnixtime: Int, endUnixtime: Int,
        context: NSManagedObjectContext
    ) {
        let gait = Gait(context: context)
        gait.record_id = Int32(recordId)
        gait.start_unixtime = Int64(startUnixtime)
        gait.end_unixtime = Int64(endUnixtime)
        try? context.save()
    }
    
    /*
     Stepの追加
     */
    func saveStep(
        recordId: Int, actionId: Int, unixtime: Int,
        context: NSManagedObjectContext
    ) {
        let step = Step(context: context)
        step.record_id = Int32(recordId)
        step.action_id = Int32(actionId)
        step.unixtime = Int64(unixtime)
        try? context.save()
    }
    
    /*
     Gaitの削除
     */
    func deleteGait(
        gaits: FetchedResults<Gait>, recordId: Int,
        context: NSManagedObjectContext
    ) {
        for gait in gaits {
            if (gait.record_id == recordId) {
                context.delete(gait)
            }
        }
        try? context.save()
    }
    
    /*
     Stepの削除
     */
    func deleteStep(
        steps: FetchedResults<Step>, recordId: Int,
        context: NSManagedObjectContext
    ) {
        for step in steps {
            if (step.record_id == recordId) {
                context.delete(step)
            }
        }
        try? context.save()
    }
    
    /*
     最新のRecordIdを取得
     */
    func getLastRecordId(
        gaits: FetchedResults<Gait>, steps: FetchedResults<Step>
    ) -> Int {
        return Int(max(gaits.first?.record_id ?? -1,
            steps.first?.record_id ?? -1))
    }
}
