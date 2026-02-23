//
//  CreateCustomLocationUseCaseTests.swift
//  PlacesTests
//
//  Created by George Coleman on 23/02/2026.
//

import XCTest
@testable import Places

final class CreateCustomLocationUseCaseTests: XCTestCase {

    private var sut: CreateCustomLocationUseCase!

    override func setUp() {
        super.setUp()
        sut = CreateCustomLocationUseCase()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_execute_validCoordinatesWithName_returnsLocation() throws {
        // Given
        let expectedLatitude = 52.3547498
        let expectedLongitude = 4.8339215
        let expectedName = "Amsterdam"

        // When
        let location = try sut.execute(name: expectedName, latitude: expectedLatitude, longitude: expectedLongitude)

        // Then
        XCTAssertEqual(location.latitude, expectedLatitude, "Expected latitude \(expectedLatitude), got \(location.latitude) instead")
        XCTAssertEqual(location.longitude, expectedLongitude, "Expected longitude \(expectedLongitude), got \(location.longitude) instead")
        XCTAssertEqual(location.name, expectedName, "Expected name \(expectedName), got \(String(describing: location.name)) instead")
    }

    func test_execute_emptyOrWhitespaceOnlyName_returnsLocationWithNilName() throws {
        // Given / When
        let nilNameLocation = try sut.execute(name: nil, latitude: 52.0, longitude: 4.0)
        let whitespaceNameLocation = try sut.execute(name: "   ", latitude: 52.0, longitude: 4.0)

        // Then
        XCTAssertNil(nilNameLocation.name, "Expected nil name, got \(String(describing: nilNameLocation.name)) instead")
        XCTAssertNil(whitespaceNameLocation.name, "Expected nil name for whitespace-only input, got \(String(describing: whitespaceNameLocation.name)) instead")
    }

    func test_execute_outOfRangeLatitude_throwsInvalidLatitude() {
        // Given
        let expected = CreateCustomLocationError.invalidLatitude

        // When / Then
        XCTAssertThrowsError(try sut.execute(name: nil, latitude: 91.0, longitude: 0.0)) { error in
            XCTAssertEqual(error as? CreateCustomLocationError, expected, "Expected \(expected), got \(error) instead")
        }
        XCTAssertThrowsError(try sut.execute(name: nil, latitude: -91.0, longitude: 0.0)) { error in
            XCTAssertEqual(error as? CreateCustomLocationError, expected, "Expected \(expected), got \(error) instead")
        }
    }

    func test_execute_outOfRangeLongitude_throwsInvalidLongitude() {
        // Given
        let expected = CreateCustomLocationError.invalidLongitude

        // When / Then
        XCTAssertThrowsError(try sut.execute(name: nil, latitude: 0.0, longitude: 181.0)) { error in
            XCTAssertEqual(error as? CreateCustomLocationError, expected, "Expected \(expected), got \(error) instead")
        }
        XCTAssertThrowsError(try sut.execute(name: nil, latitude: 0.0, longitude: -181.0)) { error in
            XCTAssertEqual(error as? CreateCustomLocationError, expected, "Expected \(expected), got \(error) instead")
        }
    }


}
