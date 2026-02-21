//
//  NetworkError.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed(Error)
}
