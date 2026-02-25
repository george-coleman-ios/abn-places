//
//  OpenLocationInWikipediaUseCase.swift
//  Places
//
//  Created by George Coleman on 22/02/2026.
//

import Foundation

enum OpenLocationInWikipediaError: Error {
    case appNotInstalled
}

protocol OpenLocationInWikipediaUseCaseProtocol: Sendable {
    func execute(location: Location) async throws
}

final class OpenLocationInWikipediaUseCase: OpenLocationInWikipediaUseCaseProtocol {
    private let urlOpener: URLOpenerProtocol

    init(urlOpener: URLOpenerProtocol) {
        self.urlOpener = urlOpener
    }

    func execute(location: Location) async throws {
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.latitude)),
            URLQueryItem(name: "longitude", value: String(location.longitude))
        ]

        if let name = location.name {
            components.queryItems?.append(URLQueryItem(name: "name", value: name))
        }

        guard let url = components.url else {
            assertionFailure("Failed to construct Wikipedia URL from components: \(components)")
            return
        }

        let opened = await urlOpener.open(url)
        if !opened {
            throw OpenLocationInWikipediaError.appNotInstalled
        }
    }
}
