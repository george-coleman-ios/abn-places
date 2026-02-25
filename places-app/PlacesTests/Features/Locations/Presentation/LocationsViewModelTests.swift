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
    private var mockCreateCustomLocationUseCase: MockCreateCustomLocationUseCase!
    private var sut: LocationsViewModel!

    override func setUp() {
        super.setUp()
        mockGetLocationsUseCase = MockGetLocationsUseCase()
        mockOpenLocationInWikipediaUseCase = MockOpenLocationInWikipediaUseCase()
        mockCreateCustomLocationUseCase = MockCreateCustomLocationUseCase()
        sut = LocationsViewModel(
            getLocationsUseCase: mockGetLocationsUseCase,
            openLocationInWikipediaUseCase: mockOpenLocationInWikipediaUseCase,
            createCustomLocationUseCase: mockCreateCustomLocationUseCase
        )
    }

    override func tearDown() {
        mockGetLocationsUseCase = nil
        mockOpenLocationInWikipediaUseCase = nil
        mockCreateCustomLocationUseCase = nil
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
        XCTAssertEqual(sut.alert, .wikipediaNotInstalled, "Expected alert .wikipediaNotInstalled, got \(String(describing: sut.alert)) instead")
    }

    func test_addCustomLocation_validInputs_appendsLocationToList() {
        // Given
        let expected = Location(name: "Test", latitude: 52.0, longitude: 4.0)
        mockCreateCustomLocationUseCase.result = .success(expected)
        sut.customLocationName = "Test"
        sut.customLocationLatitude = "52.0"
        sut.customLocationLongitude = "4.0"

        // When
        sut.addCustomLocation()

        // Then
        XCTAssertEqual(sut.customLocations.count, 1, "Expected 1 custom location, got \(sut.customLocations.count) instead")
        XCTAssertEqual(sut.customLocations.first?.name, expected.name, "Expected \(String(describing: expected.name)), got \(String(describing: sut.customLocations.first?.name)) instead")
    }

    func test_addCustomLocation_validInputs_clearsInputFields() {
        // Given
        let location = Location(name: "Test", latitude: 52.0, longitude: 4.0)
        mockCreateCustomLocationUseCase.result = .success(location)
        sut.customLocationName = "Test"
        sut.customLocationLatitude = "52.0"
        sut.customLocationLongitude = "4.0"

        // When
        sut.addCustomLocation()

        // Then
        XCTAssertTrue(sut.customLocationName.isEmpty, "Expected customLocationName to be empty, got '\(sut.customLocationName)' instead")
        XCTAssertTrue(sut.customLocationLatitude.isEmpty, "Expected customLocationLatitude to be empty, got '\(sut.customLocationLatitude)' instead")
        XCTAssertTrue(sut.customLocationLongitude.isEmpty, "Expected customLocationLongitude to be empty, got '\(sut.customLocationLongitude)' instead")
    }

    func test_addCustomLocation_commaAsDecimalSeparator_appendsLocationToList() {
        // Given
        let expected = Location(name: nil, latitude: 52.3547498, longitude: 4.8339215)
        mockCreateCustomLocationUseCase.result = .success(expected)
        sut.customLocationLatitude = "52,3547498"
        sut.customLocationLongitude = "4,8339215"

        // When
        sut.addCustomLocation()

        // Then
        XCTAssertEqual(sut.locations.count, 1, "Expected 1 location, got \(sut.locations.count) instead")
        XCTAssertEqual(mockCreateCustomLocationUseCase.executedLatitudes.first, 52.3547498, "Expected latitude 52.3547498, got \(String(describing: mockCreateCustomLocationUseCase.executedLatitudes.first)) instead")
        XCTAssertEqual(mockCreateCustomLocationUseCase.executedLongitudes.first, 4.8339215, "Expected longitude 4.8339215, got \(String(describing: mockCreateCustomLocationUseCase.executedLongitudes.first)) instead")
    }

    func test_addCustomLocation_nonNumericLatitude_setsIsShowingInvalidCoordinateAlert() {
        // Given
        sut.customLocationLatitude = "not-a-number"
        sut.customLocationLongitude = "4.0"

        // When
        sut.addCustomLocation()

        // Then
        XCTAssertEqual(sut.alert, .invalidCoordinates, "Expected alert .invalidCoordinates, got \(String(describing: sut.alert)) instead")
    }

    func test_resetCustomLocations_clearsCustomLocations() {
        // Given
        let location = Location(name: "Test", latitude: 52.0, longitude: 4.0)
        mockCreateCustomLocationUseCase.result = .success(location)
        sut.customLocationLatitude = "52.0"
        sut.customLocationLongitude = "4.0"
        sut.addCustomLocation()

        // When
        sut.resetCustomLocations()

        // Then
        XCTAssertTrue(sut.customLocations.isEmpty, "Expected customLocations to be empty, got \(sut.customLocations) instead")
    }

    func test_addCustomLocation_useCaseThrows_setsIsShowingInvalidCoordinateAlert() {
        // Given
        mockCreateCustomLocationUseCase.result = .failure(CreateCustomLocationError.invalidLatitude)
        sut.customLocationLatitude = "91.0"
        sut.customLocationLongitude = "4.0"

        // When
        sut.addCustomLocation()

        // Then
        XCTAssertEqual(sut.alert, .invalidCoordinates, "Expected alert .invalidCoordinates, got \(String(describing: sut.alert)) instead")
    }
}
