import Foundation

struct RoomAssignment: Identifiable {
    let id = UUID()
    let roomId: UUID
    let userId: String
    let startDate: Date
    let endDate: Date
    var isCompleted: Bool = false
    
    var isCurrentWeek: Bool {
        let calendar = Calendar.current
        return calendar.isDate(Date(), inSameDayAs: startDate) ||
               (Date() > startDate && Date() < endDate)
    }
} 