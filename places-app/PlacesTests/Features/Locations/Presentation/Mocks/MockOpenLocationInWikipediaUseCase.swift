//
//  MockOpenLocationInWikipediaUseCase.swift
//  PlacesTests
//
//  Created by George Coleman on 22/02/2026.
//

import Foundation
@testable import Places

final class MockOpenLocationInWikipediaUseCase: OpenLocationInWikipediaUseCaseProtocol {
    var executedLocations: [Location] = []
    var error: Error?

    func execute(location: Location) async throws {
        executedLocations.append(location)
        if let error {
            throw error
        }
    }
}
