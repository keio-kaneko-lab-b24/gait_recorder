import SwiftUI

extension Text {
    func extraLarge() -> some View {
        self.font(.system(size: 100)).fontWeight(.heavy)
    }
    
    func large() -> some View {
        self.font(.largeTitle).bold()
    }
    
    func title() -> some View {
        self.font(.title).bold().padding().padding(.top, 10)
    }
    
    func title2() -> some View {
        self.font(.title2).bold()
    }
    
    func explain() -> some View {
        self.font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
    
    func toolbar() -> some View {
        self.fontWeight(.regular).accentColor(.white).foregroundColor(.white)
    }
    
    func button() -> some View {
        self.frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40).bold()
    }
    
    func circle(enable: Bool = true) -> some View {
        self.bold()
        .padding()
        .frame(width: 100, height: 100)
        .foregroundColor(Color.white)
        .background(enable ? Color(theme) : Color(UIColor.lightGray))
        .clipShape(Circle())
    }
}
