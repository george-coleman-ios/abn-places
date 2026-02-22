//
//  LocationsRepositoryTests.swift
//  PlacesTests
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

final class LocationsRepositoryTests: XCTestCase {

    private var mockAPIClient: MockAPIClient!
    private var sut: LocationsRepository!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = LocationsRepository(apiClient: mockAPIClient)
    }

    override func tearDown() {
        mockAPIClient = nil
        sut = nil
        super.tearDown()
    }

    func test_fetchLocations_successfulResponse_returnsMappedLocations() async throws {
        // Given
        let dto = LocationsResponseDTO(locations: [
            LocationDTO(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            LocationDTO(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ])
        mockAPIClient.result = .success(dto)

        // When
        let locations = try await sut.fetchLocations()

        // Then
        XCTAssertEqual(locations.count, 2, "Expected 2 locations, got \(locations.count) instead")
        XCTAssertEqual(locations[0].name, "Amsterdam", "Expected Amsterdam, got \(String(describing: locations[0].name)) instead")
        XCTAssertEqual(locations[0].latitude, 52.3547498, "Expected 52.3547498, got \(locations[0].latitude) instead")
        XCTAssertEqual(locations[0].longitude, 4.8339215, "Expected 4.8339215, got \(locations[0].longitude) instead")
        XCTAssertNil(locations[1].name, "Expected nil name, got \(String(describing: locations[1].name)) instead")
    }

    func test_fetchLocations_successfulResponse_usesCorrectEndpoint() async throws {
        // Given
        mockAPIClient.result = .success(LocationsResponseDTO(locations: []))

        // When
        _ = try await sut.fetchLocations()

        // Then
        XCTAssertEqual(mockAPIClient.capturedEndpoint?.path, "locations.json", "Expected locations.json, got \(String(describing: mockAPIClient.capturedEndpoint?.path)) instead")
    }

    func test_fetchLocations_apiClientThrows_rethrowsError() async {
        // Given
        let expected = URLError(.notConnectedToInternet)
        mockAPIClient.result = .failure(expected)

        // When / Then
        do {
            _ = try await sut.fetchLocations()
            XCTFail("Expected error to be thrown, but fetchLocations succeeded")
        } catch let error as URLError {
            XCTAssertEqual(error.code, expected.code, "Expected \(expected.code), got \(error.code) instead")
        } catch {
            XCTFail("Expected URLError, got \(error) instead")
        }
    }
}
