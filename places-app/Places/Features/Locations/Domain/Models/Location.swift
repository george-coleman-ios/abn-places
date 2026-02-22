//
//  Location.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import Foundation

struct Location: Identifiable {
    let id: UUID
    let name: String?
    let latitude: Double
    let longitude: Double

    init(id: UUID = UUID(), name: String?, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
