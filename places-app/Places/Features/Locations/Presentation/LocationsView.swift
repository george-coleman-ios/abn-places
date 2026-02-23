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
            Divider()
            VStack(spacing: 8) {
                Group {
                    TextField("Name (optional)", text: $viewModel.customLocationName)
                    TextField("Latitude", text: $viewModel.customLocationLatitude)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $viewModel.customLocationLongitude)
                        .keyboardType(.decimalPad)
                }
                .textFieldStyle(.roundedBorder)
                Button("Add Location") {
                    viewModel.addCustomLocation()
                }
            }
            .padding()
        }
        .task {
            try? await viewModel.fetchLocations()
        }
        .alert(item: $viewModel.alert) { alert in
            return switch alert {
            case .wikipediaNotInstalled:
                Alert(title: Text("Wikipedia app not installed"))
            case .invalidCoordinates:
                Alert(title: Text("Invalid coordinates"), message: Text("Enter a valid latitude (-90 to 90) and longitude (-180 to 180)."))
            }
        }
    }
}
