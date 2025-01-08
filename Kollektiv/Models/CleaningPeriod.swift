import Foundation

enum CleaningPeriod: String, CaseIterable {
    case weekly = "Every Week"
    case biweekly = "Every Second Week"
    case monthly = "Every Month"
    
    var days: Int {
        switch self {
        case .weekly: return 7
        case .biweekly: return 14
        case .monthly: return 30
        }
    }
} 