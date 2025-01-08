import Foundation

struct Invitation: Identifiable {
    let id: UUID
    let collectiveId: UUID
    let email: String
    let username: String?  // Optional username if invited by username
    let invitedBy: String
    let status: InvitationStatus
    let dateCreated: Date
    
    init(collectiveId: UUID, email: String, username: String? = nil, invitedBy: String, status: InvitationStatus, dateCreated: Date) {
        self.id = UUID()
        self.collectiveId = collectiveId
        self.email = email
        self.username = username
        self.invitedBy = invitedBy
        self.status = status
        self.dateCreated = dateCreated
    }
    
    enum InvitationStatus: String {
        case pending = "Pending"
        case accepted = "Accepted"
        case declined = "Declined"
    }
}

// Add expiration logic to Invitation
extension Invitation {
    var isExpired: Bool {
        Calendar.current.date(byAdding: .day, value: 7, to: dateCreated)! < Date()
    }
} 