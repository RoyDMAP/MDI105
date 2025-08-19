//
//  Capsule.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/18/25.
//

import SwiftUI

struct CapsuleView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.bold)
            .padding(8)
            .background(color.opacity(0.2))
            .clipShape(Capsule())
    }
}
