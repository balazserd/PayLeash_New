//
//  View+Extensions.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 05..
//

import Foundation
import SwiftUI

//MARK:- Shadows
extension View {
    /// Draws a shadow behind your view.
    ///
    /// - Parameter color: The color of the shadow.
    /// - Parameter x: The horizontal offset of the shadow.
    /// - Parameter y: The vertical offset of the shadow.
    /// - Parameter blur: The blur radius.
    /// - Parameter spread: The spread radius. Use a negative value to reduce the shadow area concentrically.
    func shadow(color: Color = .black, x: CGFloat = 0, y: CGFloat = 0, blur: CGFloat = 0, spread: CGFloat = 0, cornerRadius: CGFloat = 8) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .padding(-spread)
                .shadow(radius: blur / 2, x: x, y: y)
        )
    }
}

//MARK:- Custom corner radius
private struct RoundedCornersClipShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let uiPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(uiPath.cgPath)
    }
}

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self.clipShape(RoundedCornersClipShape(radius: radius, corners: corners))
    }
}
