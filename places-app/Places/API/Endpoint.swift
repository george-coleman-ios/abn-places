//
//  Endpoint.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

struct Endpoint {
    let path: String

    func makeURLRequest(baseURL: URL) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}
