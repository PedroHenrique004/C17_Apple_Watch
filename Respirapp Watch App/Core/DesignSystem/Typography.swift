import SwiftUI

extension Font {
    /// Design System de Tipografia para o Respirapp
    public struct Respirapp {
        
        // MARK: - Headers & Titles
        public static let title1 = Font.system(size: 24, weight: .bold, design: .rounded)
        public static let title2 = Font.system(size: 20, weight: .semibold, design: .rounded)
        public static let title3 = Font.system(size: 18, weight: .semibold, design: .rounded)
        
        // MARK: - Body Text
        public static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        public static let bodyMedium = Font.system(size: 16, weight: .medium, design: .rounded)
        public static let bodyBold = Font.system(size: 16, weight: .bold, design: .rounded)
        
        // MARK: - Captions & Footnotes
        public static let caption = Font.system(size: 14, weight: .regular, design: .rounded)
        public static let captionMedium = Font.system(size: 14, weight: .medium, design: .rounded)
        public static let footnote = Font.system(size: 12, weight: .regular, design: .rounded)
        
        // MARK: - Special Displays
        /// Tipografia para o contador de tempo ou respiração
        public static let timerDisplay = Font.system(size: 48, weight: .light, design: .rounded).monospacedDigit()
        
        /// Tipografia para mostrar os batimentos cardíacos
        public static let heartRateValue = Font.system(size: 32, weight: .semibold, design: .rounded).monospacedDigit()
    }
}

// MARK: - ViewModifier Convenience
public extension View {
    /// Aplica uma tipografia específica do Design System do Respirapp
    func typography(_ font: Font, color: Color = .primary) -> some View {
        self
            .font(font)
            .foregroundColor(color)
    }
}
