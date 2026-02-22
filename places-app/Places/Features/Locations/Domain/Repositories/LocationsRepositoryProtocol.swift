//
//  LocationsRepositoryProtocol.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

protocol LocationsRepositoryProtocol {
    func fetchLocations() async throws -> [Location]
}
