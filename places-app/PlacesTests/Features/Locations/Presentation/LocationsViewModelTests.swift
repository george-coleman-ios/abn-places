//
//  LocationsViewModelTests.swift
//  PlacesTests
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

@MainActor
final class LocationsViewModelTests: XCTestCase {

    private var mockUseCase: MockGetLocationsUseCase!
    private var sut: LocationsViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockGetLocationsUseCase()
        sut = LocationsViewModel(getLocationsUseCase: mockUseCase)
    }

    override func tearDown() {
        mockUseCase = nil
        sut = nil
        super.tearDown()
    }

    func test_fetchLocations_successfulResponse_populatesLocations() async throws {
        // Given
        let expected = [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ]
        mockUseCase.result = .success(expected)

        // When
        try await sut.fetchLocations()

        // Then
        XCTAssertEqual(sut.locations.count, expected.count, "Expected \(expected.count) locations, got \(sut.locations.count) instead")
        XCTAssertEqual(sut.locations[0].name, expected[0].name, "Expected \(String(describing: expected[0].name)), got \(String(describing: sut.locations[0].name)) instead")
    }

    func test_fetchLocations_useCaseThrows_locationsRemainsEmpty() async {
        // Given
        mockUseCase.result = .failure(URLError(.notConnectedToInternet))

        // When
        try? await sut.fetchLocations()

        // Then
        XCTAssertTrue(sut.locations.isEmpty, "Expected locations to be empty, got \(sut.locations) instead")
    }
}
