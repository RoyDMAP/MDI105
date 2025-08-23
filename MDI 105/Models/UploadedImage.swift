//
//  UploadImage.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/23/25.
//

import SwiftData
import Foundation

@Model
class UploadedImage {
    @Attribute(.externalStorage) var imageData: Data?
    
    init(imageData: Data?) {
        self.imageData = imageData
    }
}
