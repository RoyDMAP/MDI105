//
//  SettingView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/20/25.
//

import SwiftUI

enum Theme: String, CaseIterable {
    case light, dark, system
    
    var displayName: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .system:
            return "System"
        }
    }
}
struct SettingView: View {
    @AppStorage(SETTINGS_THEME_KEY) private var theme: Theme = .system
    @AppStorage(GRID_COLUMN_NUMBER_KEY) private var gridColumnNumber: Int = 2
    @AppStorage(SETTINGS_GRID_SHOW_AUTHOR_KEY) private var gridShowAuthor: Bool = true
    @AppStorage(SETTINGS_APP_ACCENT_COLOR_KEY) private var appAccentColorString: String = "blue"

    private var appAccentColor: Color {
        AppColor(rawValue: appAccentColorString)?.color ?? .blue
    }
    var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text("Appearance")) {
                        Picker("Theme", selection: $theme) {
                            ForEach(Theme.allCases, id: \.self) { theme in
                                Text(theme.displayName)
                                    .tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            
                Section(
                    header: Text("Grid Settings"),
                    footer: Text("Adjust how books are displayed in grid views")
                ) {
                    Stepper("Columns: \(gridColumnNumber)", value: $gridColumnNumber, in: 2...4)
                        .accessibilityLabel("Grid columns")
                        .accessibilityValue("\(gridColumnNumber) columns")
                    
                    Toggle("Show Author", isOn: $gridShowAuthor)
                        .accessibilityLabel("Show author names in grid view")
                }
                
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingView()
}
