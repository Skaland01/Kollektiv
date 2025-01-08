import Foundation

struct CollectiveNotification: Identifiable {
    let id = UUID()
    let type: NotificationType
    let message: String
    let date: Date
    let collectiveId: UUID
    var isRead: Bool = false
    
    enum NotificationType {
        case memberLeft
        case memberJoined
        case invitationAccepted
        case roomAdded
        
        var icon: String {
            switch self {
            case .memberLeft: return "person.fill.xmark"
            case .memberJoined: return "person.fill.badge.plus"
            case .invitationAccepted: return "checkmark.circle.fill"
            case .roomAdded: return "house.fill"
            }
        }
    }
} 