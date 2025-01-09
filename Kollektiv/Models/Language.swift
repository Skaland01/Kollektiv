import Foundation

enum Language: String, CaseIterable {
    case english = "en"
    case german = "de"
    case french = "fr"
    case spanish = "es"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .german: return "Deutsch"
        case .french: return "Français"
        case .spanish: return "Español"
        }
    }
    
    var locale: Locale {
        Locale(identifier: self.rawValue)
    }
} 