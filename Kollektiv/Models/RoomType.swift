import Foundation

enum RoomType: String, CaseIterable {
    case kitchen = "Kitchen"
    case bathroom = "Bathroom"
    case livingRoom = "Living Room"
    case custom = "Custom"
    
    var iconName: String {
        switch self {
        case .kitchen: return "fork.knife"
        case .bathroom: return "shower.fill"
        case .livingRoom: return "sofa.fill"
        case .custom: return "square.grid.2x2"
        }
    }
}