//
//  DashboardCardModel.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 9.3.2026.
//

import Foundation

struct DashboardCardModel: Identifiable {
    enum Status { case idle, running, ok, warning, bad }

    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let status: Status
    let lastCheckedAt: Date?
}

extension DashboardCardModel {
    static func previewModel() -> DashboardCardModel {
        let model = DashboardCardModel(id: "1", title: "FileVault", subtitle: "FileVault Running State", systemImage: "shield.fill", status: .ok, lastCheckedAt: .now)
        return model
    }
}
