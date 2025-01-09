import Foundation

class RoomDistributionManager: ObservableObject {
    @Published var assignments: [String: [Room]] = [:]  // [UserId: [Rooms]]
    
    func distributeRooms(rooms: [Room], users: [User]) -> [String: [Room]] {
        guard !rooms.isEmpty && !users.isEmpty else { return [:] }
        
        var distribution: [String: [Room]] = [:]
        var remainingRooms = rooms
        
        // Initialize empty arrays for each user
        users.forEach { user in
            distribution[user.id.uuidString] = []
        }
        
        // Calculate base number of rooms per user and remainder
        let roomsPerUser = rooms.count / users.count
        let extraRooms = rooms.count % users.count
        
        // First, distribute base number of rooms to each user
        for userIndex in 0..<users.count {
            let userId = users[userIndex].id.uuidString
            let baseRooms = Array(remainingRooms.prefix(roomsPerUser))
            distribution[userId] = baseRooms
            remainingRooms.removeFirst(roomsPerUser)
        }
        
        // Then distribute extra rooms one by one
        for extraIndex in 0..<extraRooms {
            let userId = users[extraIndex].id.uuidString
            if let room = remainingRooms.first {
                distribution[userId]?.append(room)
                remainingRooms.removeFirst()
            }
        }
        
        assignments = distribution
        return distribution
    }
    
    func rotateAssignments() {
        guard !assignments.isEmpty else { return }
        
        let userIds = Array(assignments.keys).sorted()
        let rooms = userIds.flatMap { assignments[$0] ?? [] }
        
        var newAssignments: [String: [Room]] = [:]
        
        // Rotate assignments by shifting rooms to the next user
        for (index, userId) in userIds.enumerated() {
            let nextUserIndex = (index + 1) % userIds.count
            let nextUserId = userIds[nextUserIndex]
            newAssignments[userId] = assignments[nextUserId] ?? []
        }
        
        assignments = newAssignments
    }
    
    func getCurrentAssignment(for userId: String) -> [Room] {
        return assignments[userId] ?? []
    }
    
    func isRoomAssigned(to userId: String, room: Room) -> Bool {
        return assignments[userId]?.contains(where: { $0.id == room.id }) ?? false
    }
} 