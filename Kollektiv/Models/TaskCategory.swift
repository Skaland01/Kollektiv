import Foundation

enum TaskCategory: String, CaseIterable {
    case washing = "Washing"
    case cleaning = "Cleaning"
    case groceries = "Groceries"
    case maintenance = "Maintenance"
    
    var icon: String {
        switch self {
        case .washing: return "washer"
        case .cleaning: return "spray.bottle"
        case .groceries: return "cart"
        case .maintenance: return "wrench.and.screwdriver"
        }
    }
}