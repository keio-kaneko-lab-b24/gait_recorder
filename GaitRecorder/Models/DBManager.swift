import SwiftUI
import CoreData

struct DBManager {
    /*
     Gaitの追加
     */
    func saveGait(
        recordId: Int, unixtime: Int,
        context: NSManagedObjectContext
    ) {
        let gait = Gait(context: context)
        gait.record_id = Int32(recordId)
        gait.unixtime = Int64(unixtime)
        print("save gait. \(recordId), \(unixtime)")
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
        print("save step. \(recordId), \(actionId), \(unixtime)")
        do {
            try context.save()
        } catch {
            print(error)
        }
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
    
    /*
     GaitをCSV形式へ変換
     */
    func gaitToCsv(gaits: FetchedResults<Gait>) -> String {
        var text = "record_id,unixtime\n"
        for gait in gaits {
            text += "\(gait.record_id),\(gait.unixtime)\n"
        }
        return text
    }
    
    /*
     StepをCSV形式へ変換
     */
    func stepToCsv(steps: FetchedResults<Step>) -> String {
        var text = "record_id,unixtime,action_id\n"
        for step in steps {
            text += "\(step.record_id),\(step.unixtime),\(step.action_id)\n"
        }
        return text
    }
}
