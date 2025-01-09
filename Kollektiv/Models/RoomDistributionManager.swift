import Foundation

class RoomDistributionManager: ObservableObject {
    @Published var currentAssignments: [String: [Room]] = [:]
    @Published var weeklySchedule: [Int: [String: [Room]]] = [:]
    private let calendar: Calendar
    private var lastAssignmentCount: [String: Int] = [:]
    
    init() {
        // Configure calendar with Monday as first day of week
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // 2 represents Monday
        calendar.minimumDaysInFirstWeek = 4  // ISO 8601 standard
        self.calendar = calendar
    }
    
    struct WeeklySchedule: Identifiable {
        let id = UUID()
        let weekNumber: Int
        let startDate: Date
        let endDate: Date
        let assignments: [String: [Room]]
        var totalRooms: Int {
            assignments.values.reduce(0) { $0 + $1.count }
        }
    }
    
    func generateSchedule(rooms: [Room], users: [User], weeks: Int) -> [WeeklySchedule] {
        guard !rooms.isEmpty && !users.isEmpty && weeks > 0 else { return [] }
        
        var schedule: [WeeklySchedule] = []
        var currentWeekAssignments = initialDistribution(rooms: rooms, users: users)
        let startWeek = getCurrentWeek()
        
        // Generate schedule for each week
        for weekOffset in 0..<weeks {
            let weekNumber = startWeek + weekOffset
            let (weekStart, weekEnd) = getWeekDates(forWeek: weekNumber)
            
            let weekSchedule = WeeklySchedule(
                weekNumber: weekNumber,
                startDate: weekStart,
                endDate: weekEnd,
                assignments: currentWeekAssignments
            )
            
            schedule.append(weekSchedule)
            weeklySchedule[weekNumber] = currentWeekAssignments
            
            // Generate next week's assignments
            if weekOffset < weeks - 1 {
                currentWeekAssignments = generateNextWeekAssignments(
                    currentAssignments: currentWeekAssignments,
                    users: users,
                    rooms: rooms
                )
            }
        }
        
        // Set current assignments to first week
        if let firstWeek = schedule.first {
            currentAssignments = firstWeek.assignments
        }
        
        printScheduleStats(schedule)
        return schedule
    }
    
    private func initialDistribution(rooms: [Room], users: [User]) -> [String: [Room]] {
        var distribution: [String: [Room]] = [:]
        var remainingRooms = rooms
        let userIds = users.map { $0.id.uuidString }
        
        // Initialize empty arrays
        userIds.forEach { userId in
            distribution[userId] = []
            if lastAssignmentCount[userId] == nil {
                lastAssignmentCount[userId] = 0
            }
        }
        
        // Sort users by previous assignment count
        let sortedUserIds = userIds.sorted { user1, user2 in
            lastAssignmentCount[user1] ?? 0 < lastAssignmentCount[user2] ?? 0
        }
        
        // Distribute rooms fairly
        while !remainingRooms.isEmpty {
            for userId in sortedUserIds {
                guard !remainingRooms.isEmpty else { break }
                
                let currentCount = distribution[userId]?.count ?? 0
                let averageRoomsPerUser = Double(rooms.count) / Double(users.count)
                let previousAssignments = lastAssignmentCount[userId] ?? 0
                
                if Double(currentCount) < averageRoomsPerUser || 
                   previousAssignments < (lastAssignmentCount.values.max() ?? 0) {
                    distribution[userId]?.append(remainingRooms.removeFirst())
                }
            }
        }
        
        return distribution
    }
    
    private func generateNextWeekAssignments(
        currentAssignments: [String: [Room]],
        users: [User],
        rooms: [Room]
    ) -> [String: [Room]] {
        let userIds = users.map { $0.id.uuidString }.sorted()
        var newAssignments: [String: [Room]] = [:]
        
        // Rotate assignments while maintaining fairness
        for (index, userId) in userIds.enumerated() {
            let nextUserIndex = (index + 1) % userIds.count
            let nextUserId = userIds[nextUserIndex]
            
            // Transfer rooms and update counts
            if let nextUserRooms = currentAssignments[nextUserId] {
                newAssignments[userId] = nextUserRooms
                lastAssignmentCount[userId] = (lastAssignmentCount[userId] ?? 0) + nextUserRooms.count
            }
        }
        
        // Balance assignments if needed
        balanceAssignments(assignments: &newAssignments, users: users, rooms: rooms)
        
        return newAssignments
    }
    
    private func balanceAssignments(
        assignments: inout [String: [Room]],
        users: [User],
        rooms: [Room]
    ) {
        let averageRoomsPerUser = Double(rooms.count) / Double(users.count)
        let userIds = users.map { $0.id.uuidString }
        
        // Find users with too many/few rooms
        let overloadedUsers = userIds.filter { userId in
            Double(assignments[userId]?.count ?? 0) > averageRoomsPerUser + 0.5
        }
        
        let underloadedUsers = userIds.filter { userId in
            Double(assignments[userId]?.count ?? 0) < averageRoomsPerUser - 0.5
        }
        
        // Redistribute rooms if needed
        for (overloaded, underloaded) in zip(overloadedUsers, underloadedUsers) {
            if var overloadedRooms = assignments[overloaded],
               let roomToMove = overloadedRooms.popLast() {
                assignments[overloaded] = overloadedRooms
                assignments[underloaded]?.append(roomToMove)
            }
        }
    }
    
    private func getWeekDates(forWeek week: Int) -> (start: Date, end: Date) {
        let currentDate = Date()
        let weekDiff = week - getCurrentWeek()
        
        let startOfCurrentWeek = calendar.date(from: 
            calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
        ) ?? currentDate
        
        let weekStart = calendar.date(
            byAdding: .weekOfYear,
            value: weekDiff,
            to: startOfCurrentWeek
        ) ?? currentDate
        
        let weekEnd = calendar.date(
            byAdding: .day,
            value: 6,
            to: weekStart
        ) ?? weekStart
        
        return (weekStart, weekEnd)
    }
    
    private func getCurrentWeek() -> Int {
        calendar.component(.weekOfYear, from: Date())
    }
    
    private func printScheduleStats(_ schedule: [WeeklySchedule]) {
        #if DEBUG
        print("\n=== Schedule Statistics ===")
        print("Total Weeks: \(schedule.count)")
        
        for week in schedule {
            print("\nWeek \(week.weekNumber) (\(formatDate(week.startDate)) - \(formatDate(week.endDate)))")
            print("Assignments:")
            week.assignments.forEach { userId, rooms in
                print("User \(userId): \(rooms.count) rooms")
            }
        }
        
        print("\nHistorical assignment totals:")
        lastAssignmentCount.forEach { userId, count in
            print("User \(userId): \(count) total assignments")
        }
        print("========================\n")
        #endif
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func distributeRooms(rooms: [Room], users: [User]) {
        guard !rooms.isEmpty && !users.isEmpty else { return }
        let distribution = initialDistribution(rooms: rooms, users: users)
        currentAssignments = distribution
        weeklySchedule[getCurrentWeek()] = distribution
    }
    
    func rotateAssignments(users: [User]) {
        let newAssignments = generateNextWeekAssignments(
            currentAssignments: currentAssignments,
            users: users,
            rooms: currentAssignments.values.flatMap { $0 }
        )
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
} 