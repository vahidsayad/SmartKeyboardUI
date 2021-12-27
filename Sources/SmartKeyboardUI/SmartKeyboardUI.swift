import SwiftUI
import Combine

/// Note that the `KeyboardAdaptive` modifier wraps your view in a `GeometryReader`,
/// which attempts to fill all the available space, potentially increasing content view size.
///
public struct SmartKeyboardUI: ViewModifier {

    @State private var bottomPadding: CGFloat = 0
    var useGeometety = true
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    if useGeometety {
                        let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                        let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                        self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                    } else {
                        let screenHeight = UIScreen.main.bounds.size.height
                        let keyboardTop = screenHeight - keyboardHeight
                        let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                        self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                    }
                }
                .animation(.easeOut(duration: 0.16))
        }
    }
}

extension View {
    public func smartKeyboardUI(useGeometety: Bool = true) -> some View {
        ModifiedContent(content: self, modifier: SmartKeyboardUI(useGeometety: useGeometety))
    }
}
