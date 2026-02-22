//
//  LocationsViewModel.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import Combine

@MainActor
final class LocationsViewModel: ObservableObject {

    @Published var locations: [Location] = []

    private let getLocationsUseCase: GetLocationsUseCaseProtocol

    init(getLocationsUseCase: GetLocationsUseCaseProtocol) {
        self.getLocationsUseCase = getLocationsUseCase
    }

    func fetchLocations() async throws {
        locations = try await getLocationsUseCase.execute()
    }
}
