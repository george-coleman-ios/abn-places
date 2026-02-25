//
//  LocationsRepositoryProtocol.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

protocol LocationsRepositoryProtocol: Sendable {
    func fetchLocations() async throws -> [Location]
}
