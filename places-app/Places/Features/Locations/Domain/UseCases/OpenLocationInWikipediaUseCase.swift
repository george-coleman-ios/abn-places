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
        var urlString = "wikipedia://places?latitude=\(location.latitude)&longitude=\(location.longitude)"
        if let name = location.name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlString += "&name=\(name)"
        }
        guard let url = URL(string: urlString) else { return }
        let opened = await urlOpener.open(url)
        if !opened {
            throw OpenLocationInWikipediaError.appNotInstalled
        }
    }
}
