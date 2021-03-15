//
//  Date+Extensions.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 05..
//

import Foundation
import SwiftDate

extension RelativeFormatter {
    fileprivate static func payLeashStyle(for length: PayLeashStyleLength) -> Style {
        switch length {
            case .shortest:
                return Style(flavours: [.tiny, .shortTime, .narrow, .shortTime],
                             gradation: .twitter(),
                             allowedUnits: [.now, .second, .minute, .hour, .day, .other])
        }
    }
    
    fileprivate enum PayLeashStyleLength {
        case shortest
    }
}

extension Date {
    func toRelativeShortString() -> String {
        if (Date() - 7.days).compare(self) == .orderedDescending {
            return self.toFormat("d MMM")
        }
        
        return self.toRelative(style: RelativeFormatter.payLeashStyle(for: .shortest))
    }
    
    func toFullDateTimeString() -> String {
        return self.toFormat("MMM d, YYYY hh:mm")
    }
}
