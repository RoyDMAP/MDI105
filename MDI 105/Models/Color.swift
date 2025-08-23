//
//  Color.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/20/25.
//

import SwiftUI

enum AppColor: String, CaseIterable {
    case blue = "blue"
    case red = "red"
    case green = "green"
    case orange = "orange"
    case purple = "purple"
    case pink = "pink"
    case cyan = "cyan"
    case yellow = "yellow"
    case indigo = "indigo"
    case mint = "mint"
    
    var color: Color {
        switch self {
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .cyan: return .cyan
        case .yellow: return .yellow
        case .indigo: return .indigo
        case .mint: return .mint
        }
    }
}
