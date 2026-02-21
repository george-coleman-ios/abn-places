//
//  APIClient.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class APIClient: APIClientProtocol {
    private let httpClient: HTTPClient
    private let baseURL: URL
    private let decoder: JSONDecoder

    init(httpClient: HTTPClient, baseURL: URL, decoder: JSONDecoder = JSONDecoder()) {
        self.httpClient = httpClient
        self.baseURL = baseURL
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlRequest = endpoint.makeURLRequest(baseURL: baseURL)
        let (data, response) = try await httpClient.execute(urlRequest)

        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.httpError(statusCode: response.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
