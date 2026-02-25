//
//  LocationsViewModel.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import Combine
import Foundation

enum LocationsAlert: Identifiable, Equatable {
    case wikipediaNotInstalled
    case invalidCoordinates

    var id: Self { self }
}

@MainActor
final class LocationsViewModel: ObservableObject {

    @Published var locations: [Location] = []
    @Published var customLocations: [Location] = []
    @Published var alert: LocationsAlert?
    @Published var customLocationName: String = ""
    @Published var customLocationLatitude: String = ""
    @Published var customLocationLongitude: String = ""

    private let getLocationsUseCase: GetLocationsUseCaseProtocol
    private let openLocationInWikipediaUseCase: OpenLocationInWikipediaUseCaseProtocol
    private let createCustomLocationUseCase: CreateCustomLocationUseCaseProtocol

    init(
        getLocationsUseCase: GetLocationsUseCaseProtocol,
        openLocationInWikipediaUseCase: OpenLocationInWikipediaUseCaseProtocol,
        createCustomLocationUseCase: CreateCustomLocationUseCaseProtocol
    ) {
        self.getLocationsUseCase = getLocationsUseCase
        self.openLocationInWikipediaUseCase = openLocationInWikipediaUseCase
        self.createCustomLocationUseCase = createCustomLocationUseCase
    }

    func fetchLocations() async throws {
        locations = try await getLocationsUseCase.execute()
    }

    func locationPressed(_ location: Location) async {
        do {
            try await openLocationInWikipediaUseCase.execute(location: location)
        } catch {
            alert = .wikipediaNotInstalled
        }
    }

    func resetCustomLocations() {
        customLocations = []
    }

    func addCustomLocation() {
        let latitudeString = customLocationLatitude.replacingOccurrences(of: ",", with: ".")
        let longitudeString = customLocationLongitude.replacingOccurrences(of: ",", with: ".")

        guard let latitude = Double(latitudeString), let longitude = Double(longitudeString) else {
            alert = .invalidCoordinates
            return
        }

        do {
            let location = try createCustomLocationUseCase.execute(name: customLocationName, latitude: latitude, longitude: longitude)
            customLocations.append(location)
            customLocationName = ""
            customLocationLatitude = ""
            customLocationLongitude = ""
        } catch {
            alert = .invalidCoordinates
        }
    }
}
