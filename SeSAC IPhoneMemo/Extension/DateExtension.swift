

import Foundation


extension Date {
    
    enum DateCase {
        case today, week, other
    }
    
    func dateFormat(caseDate: DateCase) -> String {
        let formatter = DateFormatter()
        
        switch caseDate {
        case .today:
            formatter.dateFormat = "a hh:mm"
            formatter.amSymbol = "오전"
            formatter.pmSymbol = "오후"
            return formatter.string(from: self)
        case .week:
            formatter.dateFormat = "EEEE"
            return formatter.string(from: self)
        case .other:
            formatter.dateFormat = "yyyy.MM.dd a hh:mm"
            formatter.amSymbol = "오전"
            formatter.pmSymbol = "오후"
            return formatter.string(from: self)
        }
    }
    
    func dateChecking() -> String {
        let calendar = Calendar.current
        if calendar.dateComponents([.day, .weekOfYear, .year], from: Date()) == calendar.dateComponents([.day, .weekOfYear, .year], from: self) {
            return dateFormat(caseDate: .today)
        } else if calendar.dateComponents([.weekOfYear, .year], from: Date()) == calendar.dateComponents([.weekOfYear, .year], from: self) {
            return dateFormat(caseDate: .week)
        } else {
            return dateFormat(caseDate: .other)
        }
    }
    
}
