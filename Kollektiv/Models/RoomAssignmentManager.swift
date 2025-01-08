import Foundation

class RoomAssignmentManager: ObservableObject {
    @Published var assignments: [RoomAssignment] = []
    private var rooms: [Room]
    private var members: [String] // User IDs
    
    init(rooms: [Room], members: [String]) {
        self.rooms = rooms
        self.members = members
    }
    
    func generateAssignments() {
        guard !rooms.isEmpty && !members.isEmpty else { return }
        
        let calendar = Calendar.current
        let today = Date()
        
        // Find the next Monday
        var nextMonday = today
        while calendar.component(.weekday, from: nextMonday) != 2 {
            nextMonday = calendar.date(byAdding: .day, value: 1, to: nextMonday)!
        }
        
        // Find the following Monday (end date)
        let followingMonday = calendar.date(byAdding: .day, value: 7, to: nextMonday)!
        
        // Create new assignments
        var memberIndex = 0
        assignments = rooms.map { room in
            let assignment = RoomAssignment(
                roomId: room.id,
                userId: members[memberIndex],
                startDate: nextMonday,
                endDate: followingMonday
            )
            
            memberIndex = (memberIndex + 1) % members.count
            return assignment
        }
    }
    
    func rotateAssignments() {
        // Move each member to the next room
        let calendar = Calendar.current
        let nextMonday = calendar.date(
            byAdding: .day,
            value: 7,
            to: assignments.first?.startDate ?? Date()
        )!
        let followingMonday = calendar.date(byAdding: .day, value: 7, to: nextMonday)!
        
        // Create new assignments with rotated members
        let rotatedAssignments = assignments.enumerated().map { index, assignment in
            let nextMemberIndex = (index + 1) % members.count
            return RoomAssignment(
                roomId: assignment.roomId,
                userId: members[nextMemberIndex],
                startDate: nextMonday,
                endDate: followingMonday
            )
        }
        
        assignments = rotatedAssignments
    }
} 