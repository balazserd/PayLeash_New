//
//  Text+Extensions.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 24..
//

import Foundation
import SwiftUI

extension Text {
    func systemFont(size: CGFloat, weight: Font.Weight = .regular) -> Text {
        self
            .font(.system(size: size, weight: weight))
    }
}
