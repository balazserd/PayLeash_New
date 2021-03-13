//
//  Transitions.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import Foundation
import SwiftUI

extension AnyTransition {
    /// A Transition that grows/shrinks only in height, always having the final width.
    static let height = AnyTransition.modifier(active: HeightTransition(scale: 0.0),
                                               identity: HeightTransition(scale: 1.0))
    
    private struct HeightTransition: ViewModifier {
        var scale: CGFloat
        
        func body(content: Content) -> some View {
            content.scaleEffect(CGSize(width: 1.0, height: scale),
                                anchor: .center)
        }
    }
}
