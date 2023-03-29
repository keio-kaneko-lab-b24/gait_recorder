import Foundation

/*
 unixtime（ミリ秒）を取得する
 */
func unixtime() -> Int {
    return Int(NSDate().timeIntervalSince1970 * 1000)
}

/*
 unixtime（ミリ秒）から「xxxx年xx月xx日（x） xx:xx:xx」表記に変換する
 */
func unixtimeToDateString(unixtimeMillis: Int) -> String {
    let unixtime = Int(unixtimeMillis / 1000)
    let date = NSDate(timeIntervalSince1970: TimeInterval(unixtime))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    
    // 日付
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    let dateString = dateFormatter.string(from: date as Date)
    // 時間
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .medium
    let timeString = dateFormatter.string(from: date as Date)
    
    // 曜日
    let weekday = Calendar.current.component(.weekday, from: date as Date)
    let weekdayString = dateFormatter.shortWeekdaySymbols[weekday - 1]
    return "\(dateString)(\(weekdayString)) \(timeString)"
}

/*
 unixtime（ミリ秒）から「xx:xx:xx」表記に変換する
 */
func unixtimeToTimeString(unixtimeMillis: Int) -> String {
    let unixtime = Int(unixtimeMillis / 1000)
    let date = NSDate(timeIntervalSince1970: TimeInterval(unixtime))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .medium
    let timeString = dateFormatter.string(from: date as Date)
    return "\(timeString)"
}
