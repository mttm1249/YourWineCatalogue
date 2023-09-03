//
//  HapticFeedbackService.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import SwiftUI

enum HapticFeedbackStyle {
    case light
    case medium
    case heavy
    case error
    case success
    case warning
}

struct HapticFeedbackService {
    static func generateFeedback(style: HapticFeedbackStyle) {
        switch style {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)

        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
}

