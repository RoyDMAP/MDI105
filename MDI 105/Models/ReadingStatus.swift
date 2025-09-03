//
//  ReadingStatus.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/11/25.
//

import Foundation
import SwiftUI

enum BookStatus: String, CaseIterable, Codable, Hashable {
    case toRead = "To Read"
    case reading = "Reading"
    case finished = "Finished"
    case notStarted = "Not Started"
    case paused = "Paused"
    case abandoned = "Abandoned"
    
    
}
