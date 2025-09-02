//
//  CollageModel.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import Foundation
import SwiftData

@Model
final class Collage {
    var id: UUID
    var name: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var images: [CollageImage] = []
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}

@Model
final class CollageImage {
    var id: UUID
    var data: Data
    var collage: Collage?
    
    init(data: Data) {
        self.id = UUID()
        self.data = data
    }
}
