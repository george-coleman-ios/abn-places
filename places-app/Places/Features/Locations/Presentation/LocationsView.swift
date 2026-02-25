//
//  LocationsView.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import SwiftUI

struct LocationsView: View {
    @ObservedObject var viewModel: LocationsViewModel

    private let style = Style()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: style.listSpacing) {
                    ForEach(viewModel.locations) {
                        location in row(for: location)
                    }
                    if !viewModel.customLocations.isEmpty {
                        SectionHeader(title: "My locations")
                            .transition(.opacity)
                        ForEach(viewModel.customLocations) {
                            location in row(for: location)
                        }
                    }
                    AddLocationForm(name: $viewModel.customLocationName, latitude: $viewModel.customLocationLatitude, longitude: $viewModel.customLocationLongitude, onAdd: viewModel.addCustomLocation)
                }
                .padding()
                .animation(.easeInOut(duration: 0.3), value: viewModel.locations)
                .animation(.easeInOut(duration: 0.3), value: viewModel.customLocations)
            }
            .background(style.backgroundColor)
            .navigationTitle("Places")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !viewModel.customLocations.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Reset") {
                            viewModel.resetCustomLocations()
                        }
                        .tint(style.onAccentColor)
                    }
                }
            }
            .toolbarBackground(style.primaryColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .task {
            try? await viewModel.fetchLocations()
        }
        .alert(item: $viewModel.alert) { alert in
            return switch alert {
            case .wikipediaNotInstalled:
                Alert(title: Text("Wikipedia app not installed"))
            case .invalidCoordinates:
                Alert(
                    title: Text("Invalid coordinates"),
                    message: Text("Enter a valid latitude (-90 to 90) and longitude (-180 to 180).")
                )
            }
        }
    }

    @ViewBuilder
    private func row(for location: Location) -> some View {
        LocationRow(location: location) {
            Task { await viewModel.locationPressed(location) }
        }
        .transition(.opacity)
    }
}

private struct LocationRow: View {
    let location: Location
    let action: () -> Void

    private let style = Style()

    var body: some View {
        Button(action: action) {
            HStack(spacing: style.rowIconSpacing) {
                Image(systemName: style.locationIcon)
                    .font(style.locationIconFont)
                    .foregroundStyle(style.primaryColor)
                VStack(alignment: .leading, spacing: style.rowTitleSubtitleSpacing) {
                    Text(location.name ?? String(format: "%.4f, %.4f", location.latitude, location.longitude))
                        .font(style.rowTitleFont)
                        .fontWeight(style.rowTitleWeight)
                        .foregroundStyle(style.titleColor)
                    if location.name != nil {
                        Text(String(format: "%.4f · %.4f", location.latitude, location.longitude))
                            .font(style.rowSubtitleFont)
                            .foregroundStyle(style.secondaryTextColor)
                    }
                }
                Spacer()
                Image(systemName: style.chevronIcon)
                    .font(style.chevronFont)
                    .fontWeight(style.chevronWeight)
                    .foregroundStyle(style.secondaryTextColor)
            }
            .padding()
            .background(style.surfaceColor)
            .clipShape(RoundedRectangle(cornerRadius: style.cardCornerRadius))
        }
        .buttonStyle(.plain)
    }
}

private struct SectionHeader: View {
    let title: String

    private let style = Style()

    var body: some View {
        HStack {
            Text(title)
                .font(style.sectionHeaderFont)
                .fontWeight(style.sectionHeaderWeight)
                .foregroundStyle(style.secondaryTextColor)
            Spacer()
        }
        .padding(.horizontal, style.sectionHeaderHorizontalPadding)
        .padding(.top, style.sectionHeaderTopPadding)
    }
}

private struct AddLocationForm: View {
    @Binding var name: String
    @Binding var latitude: String
    @Binding var longitude: String
    let onAdd: () -> Void

    private let style = Style()

    var body: some View {
        VStack(alignment: .leading, spacing: style.formFieldSpacing) {
            Text("Add a location")
                .font(style.formTitleFont)
                .foregroundStyle(style.titleColor)
            Group {
                TextField("Name (optional)", text: $name)
                TextField("Latitude", text: $latitude)
                    .keyboardType(.decimalPad)
                TextField("Longitude", text: $longitude)
                    .keyboardType(.decimalPad)
            }
            .textFieldStyle(.roundedBorder)
            Button(action: onAdd) {
                Text("Add")
                    .fontWeight(style.addButtonWeight)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, style.addButtonVerticalPadding)
                    .background(style.accentColor)
                    .foregroundStyle(style.onAccentColor)
                    .clipShape(RoundedRectangle(cornerRadius: style.buttonCornerRadius))
            }
        }
        .padding()
        .background(style.surfaceColor)
        .clipShape(RoundedRectangle(cornerRadius: style.cardCornerRadius))
    }
}
