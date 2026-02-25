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
                        .accessibilityHint("Removes all custom locations")
                        .tint(style.onAccentColor)
                    }
                }
            }
            .toolbarBackground(style.primaryColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onChange(of: viewModel.locations) { oldValue, newValue in
            if oldValue.isEmpty && !newValue.isEmpty {
                AccessibilityNotification.Announcement("Locations loaded").post()
            }
        }
        .onChange(of: viewModel.customLocations) { oldValue, newValue in
            if newValue.count > oldValue.count {
                AccessibilityNotification.Announcement("Location added").post()
            } else if newValue.isEmpty && !oldValue.isEmpty {
                AccessibilityNotification.Announcement("Custom locations removed").post()
            }
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

    private var locationAccessibilityLabel: String {
        let coordinates = "Latitude \(location.latitude), Longitude \(location.longitude)"
        if let name = location.name {
            return "\(name), \(coordinates)"
        }
        return coordinates
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: style.rowIconSpacing) {
                Image(systemName: style.locationIcon)
                    .font(style.locationIconFont)
                    .foregroundStyle(style.primaryColor)
                    .accessibilityHidden(true)
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
                    .accessibilityHidden(true)
            }
            .padding()
            .background(style.surfaceColor)
            .clipShape(RoundedRectangle(cornerRadius: style.cardCornerRadius))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(locationAccessibilityLabel)
        .accessibilityHint("Opens in Wikipedia")
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
                .accessibilityAddTraits(.isHeader)
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
                .accessibilityAddTraits(.isHeader)
            Group {
                TextField("Name (optional)", text: $name)
                TextField("Latitude", text: $latitude)
                    .keyboardType(.decimalPad)
                    .accessibilityHint("Range: -90 to 90")
                TextField("Longitude", text: $longitude)
                    .keyboardType(.decimalPad)
                    .accessibilityHint("Range: -180 to 180")
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
            .accessibilityHint("Adds a custom location to the list")
        }
        .padding()
        .background(style.surfaceColor)
        .clipShape(RoundedRectangle(cornerRadius: style.cardCornerRadius))
    }
}
