//
//  LocationsResponse.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

struct LocationsResponseDTO: Decodable {
    let locations: [LocationDTO]
}

struct LocationDTO: Decodable {
    let name: String?
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}
