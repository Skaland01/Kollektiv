import Foundation

class RoomDistributionManager: ObservableObject {
    @Published var currentAssignments: [String: [Room]] = [:]  // [UserId: [Rooms]]
    @Published var weeklySchedule: [Int: [String: [Room]]] = [:]  // [WeekNumber: [UserId: [Rooms]]]
    private let calendar = Calendar.current
    
    func distributeRooms(rooms: [Room], users: [User]) {
        guard !rooms.isEmpty && !users.isEmpty else { return }
        
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
        
        currentAssignments = distribution
        weeklySchedule[getCurrentWeek()] = distribution
    }
    
    func rotateAssignments(users: [User]) {
        let userIds = users.map { $0.id.uuidString }
        var newAssignments: [String: [Room]] = [:]
        
        // Rotate assignments by shifting rooms to the next user
        for (index, userId) in userIds.enumerated() {
            let nextUserIndex = (index + 1) % userIds.count
            let nextUserId = userIds[nextUserIndex]
            newAssignments[userId] = currentAssignments[nextUserId] ?? []
        }
        
        currentAssignments = newAssignments
        weeklySchedule[getCurrentWeek() + 1] = newAssignments
    }
    
    func getCurrentAssignments(for userId: String) -> [Room] {
        return currentAssignments[userId] ?? []
    }
    
    func getUpcomingAssignments(for userId: String, weeks: Int = 4) -> [(weekNumber: Int, rooms: [Room])] {
        let currentWeek = getCurrentWeek()
        var upcoming: [(weekNumber: Int, rooms: [Room])] = []
        
        for week in currentWeek...(currentWeek + weeks) {
            if let weekAssignments = weeklySchedule[week] {
                upcoming.append((week, weekAssignments[userId] ?? []))
            }
        }
        
        return upcoming
    }
    
    private func getCurrentWeek() -> Int {
        return calendar.component(.weekOfYear, from: Date())
    }
} 