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
    ///
    /// - Parameter anchor: The point that acts as the gravity point for the growing and shrinking.
    static func height(anchor: UnitPoint = .center) -> AnyTransition {
        return AnyTransition.modifier(active: HeightTransition(scale: 0.0, anchor: anchor),
                                      identity: HeightTransition(scale: 1.0, anchor: anchor))
    }
    
    private struct HeightTransition: ViewModifier {
        var scale: CGFloat
        var anchor: UnitPoint
        
        func body(content: Content) -> some View {
            content.scaleEffect(CGSize(width: 1.0, height: scale),
                                anchor: anchor)
        }
    }
    
    /// A Transition that grows/shrinks only in width, always having the final height.
    ///
    /// - Parameter anchor: The point that acts as the gravity point for the growing and shrinking.
    static func width(anchor: UnitPoint = .center) -> AnyTransition {
        AnyTransition.modifier(active: HeightTransition(scale: 0.0, anchor: anchor),
                               identity: HeightTransition(scale: 1.0, anchor: anchor))
    }
    
    private struct WidthTransition: ViewModifier {
        var scale: CGFloat
        var anchor: UnitPoint
        
        func body(content: Content) -> some View {
            content.scaleEffect(CGSize(width: scale, height: 1.0),
                                anchor: anchor)
        }
    }
}
