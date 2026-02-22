//
//  URLOpener.swift
//  Places
//
//  Created by George Coleman on 22/02/2026.
//

import UIKit

@MainActor
final class URLOpener: URLOpenerProtocol {
    func open(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
}
