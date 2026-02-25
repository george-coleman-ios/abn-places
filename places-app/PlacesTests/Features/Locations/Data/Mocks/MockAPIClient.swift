//
//  MockAPIClient.swift
//  PlacesTests
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

final class MockAPIClient: APIClientProtocol, @unchecked Sendable {
    var result: Result<Any, Error>!
    var capturedEndpoint: Endpoint?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        capturedEndpoint = endpoint
        return try result.get() as! T
    }
}
