//
//  APIConfiguration.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import Foundation

enum APIConfiguration {
    static let baseURL: URL = {
        guard let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main") else {
            fatalError("Invalid base URL")
        }
        return url
    }()
}
