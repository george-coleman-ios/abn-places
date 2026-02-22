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
    @Published var isShowingWikipediaAlert = false

    private let getLocationsUseCase: GetLocationsUseCaseProtocol
    private let openLocationInWikipediaUseCase: OpenLocationInWikipediaUseCaseProtocol

    init(getLocationsUseCase: GetLocationsUseCaseProtocol, openLocationInWikipediaUseCase: OpenLocationInWikipediaUseCaseProtocol) {
        self.getLocationsUseCase = getLocationsUseCase
        self.openLocationInWikipediaUseCase = openLocationInWikipediaUseCase
    }

    func fetchLocations() async throws {
        locations = try await getLocationsUseCase.execute()
    }

    func locationPressed(_ location: Location) async {
        do {
            try await openLocationInWikipediaUseCase.execute(location: location)
        } catch {
            isShowingWikipediaAlert = true
        }
    }
}
