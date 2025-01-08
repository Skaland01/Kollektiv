import Foundation

struct Invitation: Identifiable {
    let id = UUID()
    let collectiveId: UUID
    let email: String
    let invitedBy: String
    let status: InvitationStatus
    let dateCreated: Date
    
    enum InvitationStatus: String {
        case pending = "Pending"
        case accepted = "Accepted"
        case declined = "Declined"
    }
} 