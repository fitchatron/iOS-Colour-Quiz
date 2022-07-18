//
//  Ext+Color.swift
//  colour-quiz
//
//  Created by James Fitch on 18/7/2022.
//

import SwiftUI

extension Color {
//    static let brandPrimary     = Color("Branding/brandPrimary")
//    static let brandSecondary   = Color("Branding/brandSecondary")
        
    var stringify: String {
        switch self {
        case .blue:
            return "blue"
        case .brown:
            return "brown"
        case .cyan:
            return "cyan"
        case .gray:
            return "gray"
        case .green:
            return "green"
        case .indigo:
            return "indigo"
        case .mint:
            return "mint"
        case .orange:
            return "orange"
        case .pink:
            return "pink"
        case .purple:
            return "purple"
        case .red:
            return "red"
        case .teal:
            return "teal"
        case .yellow:
            return "yellow"
        default:
            return "other"
        }
    }
}
