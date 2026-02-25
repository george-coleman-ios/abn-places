//
//  OpenLocationInWikipediaUseCaseTests.swift
//  PlacesTests
//
//  Created by George Coleman on 22/02/2026.
//

import XCTest
@testable import Places

final class OpenLocationInWikipediaUseCaseTests: XCTestCase {

    private var mockURLOpener: MockURLOpener!
    private var sut: OpenLocationInWikipediaUseCase!

    override func setUp() {
        super.setUp()
        mockURLOpener = MockURLOpener()
        sut = OpenLocationInWikipediaUseCase(urlOpener: mockURLOpener)
    }

    override func tearDown() {
        mockURLOpener = nil
        sut = nil
        super.tearDown()
    }

    func test_execute_locationWithName_opensWikipediaURLWithCoordinatesAndName() async throws {
        // Given
        let location = Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
        let expected = try XCTUnwrap(URL(string: "wikipedia://places?latitude=52.3676&longitude=4.9041&name=Amsterdam"))

        // When
        try await sut.execute(location: location)

        // Then
        XCTAssertEqual(mockURLOpener.openedURLs.count, 1, "Expected 1 opened URL, got \(mockURLOpener.openedURLs.count) instead")
        XCTAssertEqual(mockURLOpener.openedURLs.first, expected, "Expected \(expected), got \(String(describing: mockURLOpener.openedURLs.first)) instead")
    }

    func test_execute_locationWithoutName_opensWikipediaURLWithCoordinatesOnly() async throws {
        // Given
        let location = Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        let expected = try XCTUnwrap(URL(string: "wikipedia://places?latitude=40.4380638&longitude=-3.7495758"))

        // When
        try await sut.execute(location: location)

        // Then
        XCTAssertEqual(mockURLOpener.openedURLs.count, 1, "Expected 1 opened URL, got \(mockURLOpener.openedURLs.count) instead")
        XCTAssertEqual(mockURLOpener.openedURLs.first, expected, "Expected \(expected), got \(String(describing: mockURLOpener.openedURLs.first)) instead")
    }

    func test_execute_urlOpenerFails_throwsAppNotInstalled() async {
        // Given
        let location = Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
        mockURLOpener.shouldSucceed = false

        // When / Then
        do {
            try await sut.execute(location: location)
            XCTFail("Expected OpenLocationInWikipediaError.appNotInstalled to be thrown")
        } catch OpenLocationInWikipediaError.appNotInstalled {
            // expected
        } catch {
            XCTFail("Expected OpenLocationInWikipediaError.appNotInstalled, got \(error) instead")
        }
    }
}
