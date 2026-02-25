//
//  MockCreateCustomLocationUseCase.swift
//  PlacesTests
//
//  Created by George Coleman on 23/02/2026.
//

import XCTest
@testable import Places

final class MockCreateCustomLocationUseCase: CreateCustomLocationUseCaseProtocol, @unchecked Sendable {
    var result: Result<Location, Error>!
    var executedNames: [String?] = []
    var executedLatitudes: [Double] = []
    var executedLongitudes: [Double] = []

    func execute(name: String?, latitude: Double, longitude: Double) throws -> Location {
        executedNames.append(name)
        executedLatitudes.append(latitude)
        executedLongitudes.append(longitude)
        return try result.get()
    }
}
