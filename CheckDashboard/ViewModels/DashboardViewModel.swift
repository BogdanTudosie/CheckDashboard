//
//  DashboardViewModel.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 10.3.2026.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel : ObservableObject {
    @Published private(set) var cards: [DashboardCardModel] = []
    
    init() {
        cards = [
            .init(id: "firewall", title: "Firewall", subtitle: "Enabled & active", systemImage: "shield.fill", status: .idle, lastCheckedAt: nil),
            .init(id: "filevault", title: "FileVault", subtitle: "Off — turn it on", systemImage: "lock.fill", status: .idle, lastCheckedAt: nil),
            .init(id: "updates", title: "Auto Updates", subtitle: "Configured", systemImage: "arrow.triangle.2.circlepath", status: .idle, lastCheckedAt: nil),
            .init(id: "gatekeeper", title: "App Install Safety", subtitle: "App Store + Identified", systemImage: "checkmark.seal.fill", status: .idle, lastCheckedAt: nil),
        ]
    }
    
    func runAll() {
        for id in cards.map(\.id) {
            run(id: id)
        }
    }
    
    func run(id: String) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        cards[index] = update(cards[index], status: .running)
        
        Task {
            if id == "firewall" {
                let status = await FirwallCheck.readFirewallStatus()
                await MainActor.run {
                    guard let index = self.cards.firstIndex(where: { $0.id == id }) else { return }
                    
                    switch status {
                    case .enabled:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Enabled",
                            status: .ok,
                            checkedAt: Date()
                        )
                        
                    case .disabled:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Disabled",
                            status: .warning,
                            checkedAt: Date()
                        )
                        
                    case .unknown(let msg):
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Unknown",
                            status: .warning,
                            checkedAt: Date()
                        )
                    }
                }
            }
            
            try? await Task.sleep(nanoseconds: 600_000_000)
            await MainActor.run {
                guard let idx = self.cards.firstIndex(where: { $0.id == id }) else { return }
                
                // simple fake: mark ok except filevault warning
                let newStatus: DashboardCardModel.Status = (id == "filevault") ? .warning : .ok
                self.cards[idx] = self.update(self.cards[idx], status: newStatus, checkedAt: Date())
            }
        }
    }
    
    private func update(_ card: DashboardCardModel,
                        status: DashboardCardModel.Status,
                        checkedAt: Date? = nil) -> DashboardCardModel {
        .init(
            id: card.id,
            title: card.title,
            subtitle: card.subtitle,
            systemImage: card.systemImage,
            status: status,
            lastCheckedAt: checkedAt ?? card.lastCheckedAt
        )
    }
    
    private func updateSubtitleAndStatus(
        _ card: DashboardCardModel,
        subtitle: String,
        status: DashboardCardModel.Status,
        checkedAt: Date
    ) -> DashboardCardModel {
        .init(
            id: card.id,
            title: card.title,
            subtitle: subtitle,
            systemImage: card.systemImage,
            status: status,
            lastCheckedAt: checkedAt
        )
    }
}
