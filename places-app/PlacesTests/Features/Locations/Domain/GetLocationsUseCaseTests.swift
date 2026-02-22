//
//  GetLocationsUseCaseTests.swift
//  PlacesTests
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

final class GetLocationsUseCaseTests: XCTestCase {

    private var mockRepository: MockLocationsRepository!
    private var sut: GetLocationsUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockLocationsRepository()
        sut = GetLocationsUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }

    func test_execute_successfulResponse_returnsLocationsFromRepository() async throws {
        // Given
        let expected = [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ]
        mockRepository.result = .success(expected)

        // When
        let locations = try await sut.execute()

        // Then
        XCTAssertEqual(locations.count, expected.count, "Expected \(expected.count) locations, got \(locations.count) instead")
        XCTAssertEqual(locations[0].name, expected[0].name, "Expected \(String(describing: expected[0].name)), got \(String(describing: locations[0].name)) instead")
        XCTAssertEqual(locations[1].name, expected[1].name, "Expected nil, got \(String(describing: locations[1].name)) instead")
    }

    func test_execute_repositoryThrows_rethrowsError() async {
        // Given
        let expected = URLError(.notConnectedToInternet)
        mockRepository.result = .failure(expected)

        // When / Then
        do {
            _ = try await sut.execute()
            XCTFail("Expected error to be thrown, but execute succeeded")
        } catch let error as URLError {
            XCTAssertEqual(error.code, expected.code, "Expected \(expected.code), got \(error.code) instead")
        } catch {
            XCTFail("Expected URLError, got \(error) instead")
        }
    }
}
