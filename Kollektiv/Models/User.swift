import Foundation

struct User: Identifiable, Hashable {
    let id = UUID()
    var username: String
    var email: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
} 