//
//  BlurringOverlay.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 26..
//

import SwiftUI

fileprivate struct BlurringOverlay<Content: View> : View {
    @Binding var isShown: Bool
    var content: Content
    
    init(isShown: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isShown = isShown
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            (isShown ? Color.gray.opacity(0.2) : Color.clear)
                .animation(.linear(duration: 0.2))
                .ignoresSafeArea()
                .onTapGesture {
                    isShown = false
                }
        )
        .opacity(isShown ? 1 : 0)
        .animation(.linear(duration: 0.2))
    }
}

extension View {
    /// Presents a view in the middle of the screen, blurring the entire screen behind it.
    /// - Parameter isShown: The binding that controls whether the view is visible.
    /// - Parameter content: The view that is shown in the middle of the screen.
    ///
    /// - Important
    /// This view modifier should only be used when a top-level, full-screen, **parent** view received the `.allowsFullScreenOverlays()` modifier.
    /// Behavior is otherwise undefined and could result in a runtime exception.
    func blurringOverlay<Content: View>(isShown: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.transformPreference(FullScreenCoverPreferenceKey.self) { preferenceKey in
            preferenceKey.append(FullScreenCoverPreferenceKey.OverlayView {
                BlurringOverlay(isShown: isShown) {
                    content()
                }
            })
        }
    }
}

struct BlurringOverlay_Previews: PreviewProvider {
    @State private static var show: Bool = false
    
    static var previews: some View {
        VStack {
            Text("Hello world!")
            Button("Show overlay") {
                show = true
            }
        }
        .blurringOverlay(isShown: $show) {
            VStack {
                Text("Hello world on overlay!")
                Button("Dismiss") {
                    show = false
                }
            }
        }
    }
}
