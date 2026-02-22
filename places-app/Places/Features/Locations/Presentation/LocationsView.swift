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
                Button {
                    Task {
                        await viewModel.locationPressed(location)
                    }
                } label: {
                    Text(location.name ?? "(\(location.latitude), \(location.longitude))")
                }
            }
        }
        .task {
            try? await viewModel.fetchLocations()
        }
        .alert("Wikipedia app not installed", isPresented: $viewModel.isShowingWikipediaAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
