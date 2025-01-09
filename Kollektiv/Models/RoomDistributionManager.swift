import Foundation

class RoomDistributionManager: ObservableObject {
    @Published var currentAssignments: [String: [Room]] = [:]
    @Published var weeklySchedule: [Int: [String: [Room]]] = [:]
    private let calendar = Calendar.current
    private var lastAssignmentCount: [String: Int] = [:] // Track number of assignments per user
    
    func distributeRooms(rooms: [Room], users: [User]) {
        guard !rooms.isEmpty && !users.isEmpty else { return }
        
        var distribution: [String: [Room]] = [:]
        var remainingRooms = rooms
        let userIds = users.map { $0.id.uuidString }
        
        // Initialize empty arrays and assignment counts for each user
        userIds.forEach { userId in
            distribution[userId] = []
            if lastAssignmentCount[userId] == nil {
                lastAssignmentCount[userId] = 0
            }
        }
        
        // Sort users by their previous assignment count (ascending)
        let sortedUserIds = userIds.sorted { user1, user2 in
            lastAssignmentCount[user1] ?? 0 < lastAssignmentCount[user2] ?? 0
        }
        
        // Distribute rooms based on priority
        while !remainingRooms.isEmpty {
            for userId in sortedUserIds {
                guard !remainingRooms.isEmpty else { break }
                
                // Check if this user should get another room
                let currentCount = distribution[userId]?.count ?? 0
                let averageRoomsPerUser = Double(rooms.count) / Double(users.count)
                let previousAssignments = lastAssignmentCount[userId] ?? 0
                
                // Prioritize users with fewer previous assignments
                if Double(currentCount) < averageRoomsPerUser || previousAssignments < (lastAssignmentCount.values.max() ?? 0) {
                    distribution[userId]?.append(remainingRooms.removeFirst())
                }
            }
        }
        
        // Update assignment counts for next rotation
        distribution.forEach { userId, rooms in
            lastAssignmentCount[userId] = (lastAssignmentCount[userId] ?? 0) + rooms.count
        }
        
        currentAssignments = distribution
        weeklySchedule[getCurrentWeek()] = distribution
        
        // Log distribution stats for verification
        printDistributionStats(distribution)
    }
    
    func rotateAssignments(users: [User]) {
        let userIds = users.map { $0.id.uuidString }.sorted()
        var newAssignments: [String: [Room]] = [:]
        
        // Create a circular rotation of assignments
        for (index, userId) in userIds.enumerated() {
            let nextUserIndex = (index + 1) % userIds.count
            let nextUserId = userIds[nextUserIndex]
            
            // Transfer rooms from next user to current user
            newAssignments[userId] = currentAssignments[nextUserId] ?? []
        }
        
        // Update assignment counts
        newAssignments.forEach { userId, rooms in
            lastAssignmentCount[userId] = (lastAssignmentCount[userId] ?? 0) + rooms.count
        }
        
        currentAssignments = newAssignments
        weeklySchedule[getCurrentWeek() + 1] = newAssignments
        
        // Log rotation stats for verification
        printDistributionStats(newAssignments)
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
    
    func resetAssignmentCounts() {
        lastAssignmentCount.removeAll()
    }
    
    private func getCurrentWeek() -> Int {
        return calendar.component(.weekOfYear, from: Date())
    }
    
    private func printDistributionStats(_ distribution: [String: [Room]]) {
        #if DEBUG
        print("\n=== Room Distribution Stats ===")
        print("Total Users: \(distribution.keys.count)")
        print("Assignments per user:")
        distribution.forEach { userId, rooms in
            print("User \(userId): \(rooms.count) rooms")
        }
        print("Historical assignment counts:")
        lastAssignmentCount.forEach { userId, count in
            print("User \(userId): \(count) total assignments")
        }
        print("============================\n")
        #endif
    }
} 