//
//  MockHTTPClient.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import XCTest
@testable import Places

final class MockHTTPClient: HTTPClient, @unchecked Sendable {
    var result: Result<(Data, HTTPURLResponse), Error>!

    func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try result.get()
    }
}
