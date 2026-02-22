//
//  LocationsRepository.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

final class LocationsRepository: LocationsRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchLocations() async throws -> [Location] {
        let response: LocationsResponseDTO = try await apiClient.request(Endpoint(path: "locations.json"))
        return response.locations.map { Location(name: $0.name, latitude: $0.latitude, longitude: $0.longitude) }
    }
}
