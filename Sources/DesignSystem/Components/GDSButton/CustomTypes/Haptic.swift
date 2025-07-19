import UIKit

public enum Haptic: CaseIterable {
    case error
    case success
    case warning
    case selectionChanged
    
    case impactLight
    case impactMedium
    case impactHeavy
    
    @MainActor
    public var perform: () -> Void {
        return {
            switch self {
            case .error:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            case .success:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            case .warning:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            case .selectionChanged:
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            case .impactLight:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            case .impactMedium:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            case .impactHeavy:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        }
    }
}
