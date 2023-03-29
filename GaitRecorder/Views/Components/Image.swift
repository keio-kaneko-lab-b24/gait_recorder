import SwiftUI

extension Image {
    func circle() -> some View {
        self.padding()
            .frame(width: 100, height: 100)
            .imageScale(.large)
            .foregroundColor(Color.white)
            .background(Color.green)
            .clipShape(Circle())
    }
}
