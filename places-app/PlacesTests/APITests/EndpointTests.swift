//
//  EndpointTests.swift
//  PlacesTests
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

final class EndpointTests: XCTestCase {

    func test_makeURLRequest_buildsCorrectURL() {
        // Given
        let sut = Endpoint(path: "api/places")
        let baseURL = URL(string: "https://www.apple.com")!
        let expectedURL = URL(string: "https://www.apple.com/api/places")!

        // When
        let request = sut.makeURLRequest(baseURL: baseURL)

        // Then
        XCTAssertEqual(request.url, expectedURL, "Expected \(expectedURL), got \(String(describing: request.url)) instead")
    }
}
