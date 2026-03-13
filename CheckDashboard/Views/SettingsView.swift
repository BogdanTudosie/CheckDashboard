//
//  SettingsView.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 13.3.2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("refreshRate") var refreshRate = 15
    @AppStorage("runOnStartup") var runOnStartup: Bool = false
    @AppStorage("autoRefresh") var autoRefresh: Bool = false
    @AppStorage("enableNotifications") var enableNotifications: Bool = false
    
    var body: some View {
        Form {
            Section("General") {
                VStack(alignment: .leading, spacing: 4) {
                    Toggle("Run on startup", isOn: $runOnStartup)
                    Text("Launch CheckDashboard automatically when you log in")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Toggle("Automatic refresh", isOn: $autoRefresh)
                    Text("Run security checks at regular intervals")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Picker("Refresh Rate", selection: $refreshRate) {
                    Text("5 minutes").tag(5)
                    Text("10 minutes").tag(10)
                    Text("15 minutes").tag(15)
                    Text("30 minutes").tag(30)
                }
            }

            Section("Notifications") {
                VStack(alignment: .leading, spacing: 4) {
                    Toggle("Enable notifications", isOn: $enableNotifications)
                    Text("Get alerts when security status changes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("About") {
                LabeledContent("Version", value: "1.0.0")
                LabeledContent("Platform", value: "macOS 14.0+")
                Link("View on GitHub", destination: URL(string: "https://github.com/BogdanTudosie/CheckDashboard")!)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

#Preview {
    SettingsView()
}
