import SwiftUI

/// Copy from: https://www.avanderlee.com/swiftui/conditional-view-modifier/

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evalute.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transofrm: (Self) -> Content) -> some View {
        if condition {
            transofrm(self)
        } else {
            self
        }
    }
}

extension Bool {
    static var iOS13: Bool {
        guard #available(iOS 14, *) else {
            return true
        }
        return false
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello world!")
            .padding()
            .if(.iOS13) { view in
                view.background(.red)
            }
    }
}
