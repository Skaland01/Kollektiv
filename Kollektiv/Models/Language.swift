import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case norwegian = "nb"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .norwegian: return "Norsk"
        }
    }
    
    var icon: String {
        switch self {
        case .english: return "🇬🇧"
        case .norwegian: return "🇳��"
        }
    }
} 