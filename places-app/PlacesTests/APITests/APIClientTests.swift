//
//  APIClientTests.swift
//  PlacesTests
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

final class APIClientTests: XCTestCase {

    private var mockHTTPClient: MockHTTPClient!
    private var sut: APIClient!

    // swiftlint:disable:next force_unwrapping
    private let baseURL = URL(string: "https://www.apple.com")!

    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        sut = APIClient(httpClient: mockHTTPClient, baseURL: baseURL)
    }

    override func tearDown() {
        mockHTTPClient = nil
        sut = nil
        super.tearDown()
    }

    func test_request_successfulResponse_decodesCorrectly() async throws {
        // Given
        let expected = Place(name: "Place")
        let data = try JSONEncoder().encode(expected)
        mockHTTPClient.result = .success((data, makeHTTPResponse(statusCode: 200)))

        // When
        let result: Place = try await sut.request(Endpoint(path: "places"))

        // Then
        XCTAssertEqual(result, expected, "Expected \(expected), got \(result) instead")
    }

    func test_request_nonSuccessStatusCode_throwsHTTPError() async {
        // Given
        let data = Data()
        mockHTTPClient.result = .success((data, makeHTTPResponse(statusCode: 500)))

        // When / Then
        do {
            let _: Place = try await sut.request(Endpoint(path: "places"))
            XCTFail("Expected NetworkError.httpError, but request succeeded")
        } catch let error as NetworkError {
            guard case .httpError(let statusCode) = error else {
                return XCTFail("Expected NetworkError.httpError, got \(error) instead")
            }
            XCTAssertEqual(statusCode, 500, "Expected status code 500, got \(statusCode) instead")
        } catch {
            XCTFail("Expected NetworkError.httpError, got \(error) instead")
        }
    }

    func test_request_httpClientThrows_rethrowsError() async {
        // Given
        let expected = URLError(.notConnectedToInternet)
        mockHTTPClient.result = .failure(expected)

        // When / Then
        do {
            let _: Place = try await sut.request(Endpoint(path: "places"))
            XCTFail("Expected URLError to be thrown, but request succeeded")
        } catch let error as URLError {
            XCTAssertEqual(error.code, expected.code, "Expected \(expected.code), got \(error.code) instead")
        } catch {
            XCTFail("Expected URLError, got \(error) instead")
        }
    }

    func test_request_invalidJSON_throwsDecodingFailed() async {
        // Given
        let invalidJSON = Data("not json".utf8)
        mockHTTPClient.result = .success((invalidJSON, makeHTTPResponse(statusCode: 200)))

        // When / Then
        do {
            let _: Place = try await sut.request(Endpoint(path: "places"))
            XCTFail("Expected NetworkError.decodingFailed, but request succeeded")
        } catch let error as NetworkError {
            guard case .decodingFailed = error else {
                return XCTFail("Expected NetworkError.decodingFailed, got \(error) instead")
            }
        } catch {
            XCTFail("Expected NetworkError.decodingFailed, got \(error) instead")
        }
    }
}

// MARK: - Helpers
extension APIClientTests {
    private func makeHTTPResponse(statusCode: Int) -> HTTPURLResponse {
        // swiftlint:disable:next force_unwrapping
        HTTPURLResponse(url: baseURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

private struct Place: Codable, Equatable {
    let name: String
}
