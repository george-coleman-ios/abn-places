//
//  GetLocationsUseCase.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

protocol GetLocationsUseCaseProtocol {
    func execute() async throws -> [Location]
}

final class GetLocationsUseCase: GetLocationsUseCaseProtocol {
    private let repository: LocationsRepositoryProtocol

    init(repository: LocationsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Location] {
        try await repository.fetchLocations()
    }
}
