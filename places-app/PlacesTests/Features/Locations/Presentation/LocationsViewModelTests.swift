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

    private var mockGetLocationsUseCase: MockGetLocationsUseCase!
    private var mockOpenLocationInWikipediaUseCase: MockOpenLocationInWikipediaUseCase!
    private var sut: LocationsViewModel!

    override func setUp() {
        super.setUp()
        mockGetLocationsUseCase = MockGetLocationsUseCase()
        mockOpenLocationInWikipediaUseCase = MockOpenLocationInWikipediaUseCase()
        sut = LocationsViewModel(
            getLocationsUseCase: mockGetLocationsUseCase,
            openLocationInWikipediaUseCase: mockOpenLocationInWikipediaUseCase
        )
    }

    override func tearDown() {
        mockGetLocationsUseCase = nil
        mockOpenLocationInWikipediaUseCase = nil
        sut = nil
        super.tearDown()
    }

    func test_fetchLocations_successfulResponse_populatesLocations() async throws {
        // Given
        let expected = [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ]
        mockGetLocationsUseCase.result = .success(expected)

        // When
        try await sut.fetchLocations()

        // Then
        XCTAssertEqual(sut.locations.count, expected.count, "Expected \(expected.count) locations, got \(sut.locations.count) instead")
        XCTAssertEqual(sut.locations[0].name, expected[0].name, "Expected \(String(describing: expected[0].name)), got \(String(describing: sut.locations[0].name)) instead")
    }

    func test_fetchLocations_useCaseThrows_locationsRemainsEmpty() async {
        // Given
        mockGetLocationsUseCase.result = .failure(URLError(.notConnectedToInternet))

        // When
        try? await sut.fetchLocations()

        // Then
        XCTAssertTrue(sut.locations.isEmpty, "Expected locations to be empty, got \(sut.locations) instead")
    }

    func test_locationPressed_callsUseCaseWithLocation() async {
        // Given
        let location = Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215)

        // When
        await sut.locationPressed(location)

        // Then
        XCTAssertEqual(mockOpenLocationInWikipediaUseCase.executedLocations.count, 1, "Expected 1 executed location, got \(mockOpenLocationInWikipediaUseCase.executedLocations.count) instead")
        XCTAssertEqual(mockOpenLocationInWikipediaUseCase.executedLocations.first?.name, location.name, "Expected location name \(String(describing: location.name)), got \(String(describing: mockOpenLocationInWikipediaUseCase.executedLocations.first?.name)) instead")
    }

    func test_locationPressed_useCaseThrows_setsIsShowingWikipediaAlert() async {
        // Given
        let location = Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215)
        mockOpenLocationInWikipediaUseCase.error = OpenLocationInWikipediaError.appNotInstalled

        // When
        await sut.locationPressed(location)

        // Then
        XCTAssertTrue(sut.isShowingWikipediaAlert, "Expected isShowingWikipediaAlert to be true, got false instead")
    }
}
