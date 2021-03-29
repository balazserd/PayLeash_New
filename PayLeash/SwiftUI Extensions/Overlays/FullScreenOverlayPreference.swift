//
//  FullScreenOverlayPreference.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 27..
//

import Foundation
import SwiftUI

/// A preference that allows you to show full screen overlays on top of any top-level full screen view.
///
/// This is particularly useful when trying to present views over a `TabView` or a `NavigationView` which block placing views over
/// their respective safe zones (like the tab bar or the navigation bar).
struct FullScreenCoverPreferenceKey: PreferenceKey {
    typealias Value = [OverlayView]
    static var defaultValue: [OverlayView] = []
    
    static func reduce(value: inout [OverlayView], nextValue: () -> [OverlayView]) {
        value.append(contentsOf: nextValue())
    }
    
    /// The underlying overlay view behind the preference key.
    struct OverlayView: View, Identifiable {
        let id = UUID()
        
        var content: AnyView
        
        init<Content: View>(@ViewBuilder content: () -> Content) {
            self.content = AnyView(content())
        }
        
        var body: some View {
            content
        }
    }
}

extension View {
    /// Declares that this view is capable of receiving full screen overlays.
    ///
    /// - Important
    /// This modifier should only be used on views that are taking up the entire screen.
    func allowFullScreenOverlays() -> some View {
        self
            .overlayPreferenceValue(FullScreenCoverPreferenceKey.self) { overlayViewsArray in
                ZStack {
                    ForEach(overlayViewsArray) { overlayView in
                        overlayView
                    }
                }
            }
    }
}
