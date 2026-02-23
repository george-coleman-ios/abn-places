//
//  CreateCustomLocationUseCase.swift
//  Places
//
//  Created by George Coleman on 23/02/2026.
//

import Foundation

enum CreateCustomLocationError: Error, Equatable {
    case invalidLatitude
    case invalidLongitude
}

protocol CreateCustomLocationUseCaseProtocol {
    func execute(name: String?, latitude: Double, longitude: Double) throws -> Location
}

final class CreateCustomLocationUseCase: CreateCustomLocationUseCaseProtocol {
    func execute(name: String?, latitude: Double, longitude: Double) throws -> Location {
        guard (-90...90).contains(latitude) else { throw CreateCustomLocationError.invalidLatitude }
        guard (-180...180).contains(longitude) else { throw CreateCustomLocationError.invalidLongitude }
        let trimmedName = name?.trimmingCharacters(in: .whitespaces)
        return Location(name: trimmedName?.isEmpty == true ? nil : trimmedName, latitude: latitude, longitude: longitude)
    }
}
