import SwiftUI

enum Avatar: String, CaseIterable, Identifiable {
    case person = "person.circle.fill"
    case personCrop = "person.crop.circle.fill"
    case personText = "person.text.rectangle.fill"
    case star = "star.circle.fill"
    case heart = "heart.circle.fill"
    case house = "house.circle.fill"
    case gear = "gearshape.circle.fill"
    case bell = "bell.circle.fill"
    case bookmark = "bookmark.circle.fill"
    case bolt = "bolt.circle.fill"
    
    var id: String { rawValue }
    
    var image: Image {
        Image(systemName: rawValue)
    }
    
    var displayName: String {
        rawValue
            .replacingOccurrences(of: ".circle.fill", with: "")
            .replacingOccurrences(of: ".crop", with: "")
            .replacingOccurrences(of: ".text.rectangle", with: "")
            .capitalized
    }
    
    static var defaultAvatar: Avatar { .person }
} 