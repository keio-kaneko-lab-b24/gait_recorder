import SwiftUI

extension Button {
    func primary() -> some View {
        self.buttonStyle(.borderedProminent)
            .tint(Color(theme))
            .foregroundColor(.white)
    }
    
    func secondary() -> some View {
        self.buttonStyle(.bordered)
    }
}
