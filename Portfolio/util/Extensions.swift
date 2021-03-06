
import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

extension SequenceType {

    /// Categorises elements of self into a dictionary, with the keys given by keyFunc

    func categorise<U : Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U:[Generator.Element]] {
        var dict: [U:[Generator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

extension NSDate {

    func onlyYear()-> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return dateFormatter.stringFromDate(self)
    }

    func shortPrintable()-> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        return dateFormatter.stringFromDate(self)
    }

    func mediumMinusPrintable()-> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"

        return dateFormatter.stringFromDate(self)
    }
    
    func mediumPrintable() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd. MMMM YYYY"
        
        return dateFormatter.stringFromDate(self)
    }

    func timeOfDayPrintable() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        return dateFormatter.stringFromDate(self)
    }

    func timeOfDayShortPrintable() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.stringFromDate(self)
    }
    
    func utcFormat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return dateFormatter.stringFromDate(self)
    }

    func relativePrintable() -> String {
        let elapsedTime = self.timeIntervalSinceNow * -1
        if elapsedTime < 60 {
            return "\(Int(elapsedTime))s"
        } else if elapsedTime < 3600 {
            return "\(Int(elapsedTime / 60))m"
        } else if elapsedTime < 86400.0 {
            return "\(Int(elapsedTime / 3600))h"
        } else {
            return "\(Int(elapsedTime / 86400))d"
        }
    }

    struct Calendar {
        static let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    }
    func isInSameDayAs(date date: NSDate) -> Bool {
        return Calendar.gregorian.isDate(self, inSameDayAsDate: date)
    }

    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

extension UITableView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
        { _ in completion() }
    }
}