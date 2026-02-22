//
//  PlacesApp.swift
//  Places
//
//  Created by George Coleman on 20/02/2026.
//

import SwiftUI

@main
struct PlacesApp: App {

    private let viewModel = LocationsViewModel(
        getLocationsUseCase: GetLocationsUseCase(repository: LocationsRepository()),
        openLocationInWikipediaUseCase: OpenLocationInWikipediaUseCase(urlOpener: URLOpener())
    )

    var body: some Scene {
        WindowGroup {
            LocationsView(viewModel: viewModel)
        }
    }
}
