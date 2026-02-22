//
//  URLOpenerProtocol.swift
//  Places
//
//  Created by George Coleman on 22/02/2026.
//

import Foundation

protocol URLOpenerProtocol {
    func open(_ url: URL) async -> Bool
}
