//
//  PlacesApp.swift
//  Places
//
//  Created by George Coleman on 20/02/2026.
//

import SwiftUI

@main
struct PlacesApp: App {

    private let viewModel = LocationsViewModel(getLocationsUseCase: GetLocationsUseCase(repository: LocationsRepository()))

    var body: some Scene {
        WindowGroup {
            LocationsView(viewModel: viewModel)
        }
    }
}
