//
//  URLOpenerProtocol.swift
//  Places
//
//  Created by George Coleman on 22/02/2026.
//

import Foundation

protocol URLOpenerProtocol: Sendable {
    func open(_ url: URL) async -> Bool
}
