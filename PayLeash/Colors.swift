//
//  Colors.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import SwiftUI

struct Colors {
    //MARK:- Green
    struct Green {
        static func typed(_ type: GreenColorType) -> Color {
            return Color(type.rawValue)
        }
    }
    
    enum GreenColorType: String {
        case extraLightGreen
        case backgroundGreen
        case lowMediumGreen
        case cardBackgroundGreen
        case mediumGreen
        case prominentGreen
    }
    
    //MARK:- Red
    struct Red {
        static func typed(_ type: RedColorType) -> Color {
            return Color(type.rawValue)
        }
    }
    
    enum RedColorType: String {
        case fadedRed
        case regularRed
    }
    
    //MARK:- Gray
    struct Gray {
        static func typed(_ type: GrayColorType) -> Color {
            return Color(type.rawValue)
        }
    }
    
    enum GrayColorType: String {
        case extraLightGray
        case lightGray
    }
}


