import Foundation

struct Room: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var description: String = ""
    var assignedMembers: [String] = []  // User IDs of assigned members
    var lastCleaned: Date?
    
    // For Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        lhs.id == rhs.id
    }
} 