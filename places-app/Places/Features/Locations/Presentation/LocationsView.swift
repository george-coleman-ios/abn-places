//
//  LocationsView.swift
//  Places
//
//  Created by George Coleman on 21/02/2026.
//

import SwiftUI

struct LocationsView: View {
    @Bindable var viewModel: LocationsViewModel

    private let style = LocationsStyle()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: style.listSpacing) {
                    switch viewModel.contentState {
                        case .loading:
                            ProgressView("Loading locations")
                                .padding(.vertical, style.listPadding)
                        case .error:
                            errorCard
                        case .loaded:
                            ForEach(viewModel.locations) { location in
                                row(for: location)
                            }
                    }
                    if !viewModel.customLocations.isEmpty {
                        SectionHeader(title: "My locations")
                            .transition(.opacity)
                        ForEach(viewModel.customLocations) { location in
                            row(for: location)
                        }
                    }
                    AddLocationForm(name: $viewModel.customLocationName, latitude: $viewModel.customLocationLatitude, longitude: $viewModel.customLocationLongitude, onAdd: viewModel.addCustomLocation)
                }
                .padding(.all, style.listPadding)
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
        .onChange(of: viewModel.contentState) { _, newValue in
            if newValue == .error {
                AccessibilityNotification.Announcement("Failed to load locations").post()
            }
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
            await viewModel.fetchLocations()
        }
        .alert(
            viewModel.alert?.title ?? "",
            isPresented: Binding(
                get: { viewModel.alert != nil },
                set: { if !$0 { viewModel.alert = nil } }
            ),
            presenting: viewModel.alert
        ) { _ in
            Button("OK", role: .cancel) { }
        } message: { alert in
            if let message = alert.message {
                Text(message)
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

    private var errorCard: some View {
        VStack(spacing: style.formFieldSpacing) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundStyle(style.secondaryTextColor)
                .accessibilityHidden(true)
            Text("Unable to load locations")
                .font(style.rowTitleFont)
                .fontWeight(style.rowTitleWeight)
                .foregroundStyle(style.titleColor)
            Text("Check your connection and try again.")
                .font(style.rowSubtitleFont)
                .foregroundStyle(style.secondaryTextColor)
            Button {
                Task { await viewModel.fetchLocations() }
            } label: {
                Text("Retry")
                    .fontWeight(style.addButtonWeight)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, style.addButtonVerticalPadding)
                    .background(style.accentColor)
                    .foregroundStyle(style.onAccentColor)
                    .clipShape(RoundedRectangle(cornerRadius: style.buttonCornerRadius))
            }
        }
        .padding(.all, style.cardPadding)
        .background(style.surfaceColor)
        .clipShape(RoundedRectangle(cornerRadius: style.cardCornerRadius))
    }
}

private struct LocationRow: View {
    let location: Location
    let action: () -> Void

    private let style = LocationsStyle()

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
            .padding(.all, style.cardPadding)
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

    private let style = LocationsStyle()

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

    @FocusState private var focusedField: CoordinateField?

    private let style = LocationsStyle()

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
                    .focused($focusedField, equals: .latitude)
                TextField("Longitude", text: $longitude)
                    .keyboardType(.decimalPad)
                    .accessibilityHint("Range: -180 to 180")
                    .focused($focusedField, equals: .longitude)
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
        .padding(.all, style.formPadding)
        .background(style.surfaceColor)
        .clipShape(RoundedRectangle(cornerRadius: style.cardCornerRadius))
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                if focusedField != nil {
                    HStack {
                        Button {
                            toggleSign()
                        } label: {
                            Text("+/−")
                        }
                        .accessibilityLabel("Toggle sign")
                        .accessibilityHint("Switches between positive and negative")
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
        }
    }

    private func toggleSign() {
        switch focusedField {
            case .latitude:
                latitude = toggleLeadingMinus(latitude)
            case .longitude:
                longitude = toggleLeadingMinus(longitude)
            case nil:
                break
        }
    }

    private func toggleLeadingMinus(_ value: String) -> String {
        if value.hasPrefix("-") {
            return String(value.dropFirst())
        }
        return "-" + value
    }

    private enum CoordinateField {
        case latitude, longitude
    }
}
