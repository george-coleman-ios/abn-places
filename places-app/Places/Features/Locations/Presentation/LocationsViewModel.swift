//
//  LocationsViewModel.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import Observation
import Foundation

enum ContentState {
    case loading
    case loaded
    case error
}

enum LocationsAlert: Identifiable, Equatable {
    case wikipediaNotInstalled
    case invalidCoordinates

    var id: Self { self }
}

@MainActor
@Observable
final class LocationsViewModel {

    var locations: [Location] = []
    var customLocations: [Location] = []
    var contentState: ContentState = .loading
    var alert: LocationsAlert?
    var customLocationName: String = ""
    var customLocationLatitude: String = ""
    var customLocationLongitude: String = ""

    private let getLocationsUseCase: GetLocationsUseCaseProtocol
    private let openLocationInWikipediaUseCase: OpenLocationInWikipediaUseCaseProtocol
    private let createCustomLocationUseCase: CreateCustomLocationUseCaseProtocol

    init(getLocationsUseCase: GetLocationsUseCaseProtocol,
         openLocationInWikipediaUseCase: OpenLocationInWikipediaUseCaseProtocol,
         createCustomLocationUseCase: CreateCustomLocationUseCaseProtocol) {
        self.getLocationsUseCase = getLocationsUseCase
        self.openLocationInWikipediaUseCase = openLocationInWikipediaUseCase
        self.createCustomLocationUseCase = createCustomLocationUseCase
    }

    func fetchLocations() async {
        contentState = .loading
        do {
            locations = try await getLocationsUseCase.execute()
            contentState = .loaded
        } catch {
            contentState = .error
        }
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
