//
//  LocationsView.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import SwiftUI

struct LocationsView: View {
    @ObservedObject var viewModel: LocationsViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.locations) { location in
                Text(location.name ?? "name missing: (\(location.latitude), \(location.longitude))")
            }
        }
        .task {
            try? await viewModel.fetchLocations()
        }
    }
}
