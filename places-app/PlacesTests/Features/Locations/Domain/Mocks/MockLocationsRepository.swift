//
//  MockLocationsRepository.swift
//  PlacesTests
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

final class MockLocationsRepository: LocationsRepositoryProtocol, @unchecked Sendable {
    var result: Result<[Location], Error>!

    func fetchLocations() async throws -> [Location] {
        try result.get()
    }
}
