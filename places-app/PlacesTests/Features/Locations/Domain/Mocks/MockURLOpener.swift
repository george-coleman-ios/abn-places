//
//  MockURLOpener.swift
//  PlacesTests
//
//  Created by George Coleman on 22/02/2026.
//

import Foundation
@testable import Places

final class MockURLOpener: URLOpenerProtocol {
    var openedURLs: [URL] = []
    var shouldSucceed = true

    func open(_ url: URL) async -> Bool {
        openedURLs.append(url)
        return shouldSucceed
    }
}
