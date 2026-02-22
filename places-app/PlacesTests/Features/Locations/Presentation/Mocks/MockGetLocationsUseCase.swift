//
//  MockGetLocationsUseCase.swift
//  PlacesTests
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

final class MockGetLocationsUseCase: GetLocationsUseCaseProtocol {
    var result: Result<[Location], Error>!

    func execute() async throws -> [Location] {
        try result.get()
    }
}
