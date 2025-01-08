import Foundation

struct User: Identifiable {
    let id: UUID
    var username: String
    var email: String
    var role: UserRole
    
    enum UserRole: String {
        case admin = "Admin"
        case member = "Member"
    }
    
    init(id: UUID = UUID(), username: String, email: String, role: UserRole = .member) {
        self.id = id
        self.username = username
        self.email = email
        self.role = role
    }
} 