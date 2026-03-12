//
//  CardView.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 9.3.2026.
//

import SwiftUI

struct CardView: View {
    let model: DashboardCardModel
    let onRun: () -> Void
    let onOpenSettings: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: model.systemImage)
                    .font(.title2)

                Spacer()

                statusPill
            }

            Text(model.title)
                .font(.headline)

            Text(model.subtitle)
                .foregroundStyle(.secondary)

            Spacer(minLength: 0)

            HStack {
                Text("Last checked: \(lastCheckedText)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Run") { onRun() }
                    .buttonStyle(.bordered)

                Button("Open Settings") { onOpenSettings() }
                    .buttonStyle(.bordered)
            }
        }
        .padding(16)
        .frame(minHeight: 150)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var lastCheckedText: String {
        guard let date = model.lastCheckedAt else { return "—" }
        return date.formatted(date: .omitted, time: .shortened)
    }

    private var statusPill: some View {
        let (text, image): (String, String) = switch model.status {
        case .idle: ("Not checked", "minus.circle.fill")
        case .ok: ("All good", "checkmark.circle.fill")
        case .warning: ("Worth a look", "exclamationmark.triangle.fill")
        case .bad: ("Needs attention", "xmark.octagon.fill")
        case .running: ("Running…", "arrow.triangle.2.circlepath")
        }

        return Label(text, systemImage: image)
            .font(.caption).fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
    }
}

#Preview {
    CardView(model: .previewModel(), onRun: {}, onOpenSettings: {})
}
