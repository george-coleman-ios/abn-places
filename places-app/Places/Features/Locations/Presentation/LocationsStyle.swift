//
//  LocationsStyle.swift
//  Places
//
//  Created by George Coleman on 25/02/2026.
//

import SwiftUI

struct LocationsStyle {
    // MARK: Floats

    let listSpacing: CGFloat = 12
    let rowIconSpacing: CGFloat = 14
    let rowTitleSubtitleSpacing: CGFloat = 2
    let formFieldSpacing: CGFloat = 12
    let sectionHeaderHorizontalPadding: CGFloat = 4
    let sectionHeaderTopPadding: CGFloat = 4
    let addButtonVerticalPadding: CGFloat = 12
    let listPadding: CGFloat = 16
    let cardPadding: CGFloat = 16
    let formPadding: CGFloat = 16
    let cardCornerRadius: CGFloat = 12
    let buttonCornerRadius: CGFloat = 10

    // MARK: Colors

    let backgroundColor = Color.abnBackground
    let primaryColor = Color.abnPrimary
    let surfaceColor = Color.abnSurface
    let secondaryTextColor = Color.abnSecondaryText
    let accentColor = Color.abnYellow
    let onAccentColor = Color.abnOnAccent
    let titleColor = Color.primary

    // MARK: Icons

    let locationIcon = "mappin.circle.fill"
    let chevronIcon = "chevron.right"

    // MARK: Fonts

    let locationIconFont = Font.title2
    let rowTitleFont = Font.body
    let rowTitleWeight = Font.Weight.medium
    let rowSubtitleFont = Font.caption
    let chevronFont = Font.caption
    let chevronWeight = Font.Weight.semibold
    let sectionHeaderFont = Font.subheadline
    let sectionHeaderWeight = Font.Weight.semibold
    let formTitleFont = Font.headline
    let addButtonWeight = Font.Weight.semibold
}
