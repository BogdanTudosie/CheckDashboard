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
    private var runTokens: [CheckKind: UUID] = [:]
    
    init() {
        cards = [
            .init(id: .firewall, title: "Firewall", subtitle: "Enabled & active", systemImage: "shield.fill", status: .idle, lastCheckedAt: nil),
            .init(id: .filevault, title: "FileVault", subtitle: "Off — turn it on", systemImage: "lock.fill", status: .idle, lastCheckedAt: nil),
            .init(id: .updates, title: "Auto Updates", subtitle: "Configured", systemImage: "arrow.triangle.2.circlepath", status: .idle, lastCheckedAt: nil),
            .init(id: .gatekeeper, title: "App Install Safety", subtitle: "App Store + Identified", systemImage: "checkmark.seal.fill", status: .idle, lastCheckedAt: nil),
        ]
    }
    
    func runAll() {
        for id in cards.map(\.id) {
            run(id: id)
        }
    }
    
    func run(id: CheckKind) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        cards[index] = update(cards[index], status: .running)
        let token = UUID()
        runTokens[id] = token
        
        Task {
            switch id {
            case .firewall:
                let status = await FirewallCheck.readFirewallStatus()
                await MainActor.run {
                    guard let index = self.cards.firstIndex(where: { $0.id == id }) else { return }
                    guard self.runTokens[id] == token else { return }
                    
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
                        
                    case .unknown:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Unknown",
                            status: .warning,
                            checkedAt: Date()
                        )
                    }
                    
                    self.runTokens[id] = nil
                }
                
            case .filevault:
                let status = await FileVaultCheck.getStatus()
                await MainActor.run {
                    guard let index = self.cards.firstIndex(where: { $0.id == id }) else { return }
                    guard self.runTokens[id] == token else { return }
                    
                    switch status {
                    case .on:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "On",
                            status: .ok,
                            checkedAt: Date())
                        
                    case .encrypting:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Encrypting...",
                            status: .running,
                            checkedAt: Date())
                        
                    case .decrypting:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Decrypting...",
                            status: .running,
                            checkedAt: Date())
                        
                    case .off:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Off",
                            status: .idle,
                            checkedAt: Date())
                                
                    case .unknown:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Unknown",
                            status: .warning,
                            checkedAt: Date())
                    }
                    
                    self.runTokens[id] = nil
                }
                
            case .gatekeeper:
                let status = await GatekeeperCheck.getStatus()
                await MainActor.run {
                    guard let index = self.cards.firstIndex(where: { $0.id == id }) else { return }
                    guard self.runTokens[id] == token else { return }

                    switch status {
                    case .enabled:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Enabled",
                            status: .ok,
                            checkedAt: Date())
                    case .disabled:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Disabled",
                            status: .warning,
                            checkedAt: Date())
                    case .unknown:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Unknown",
                            status: .warning,
                            checkedAt: Date())
                    }
                    
                    self.runTokens[id] = nil
                }
                
            case .updates:
                let status = await AutoUpdatesCheck.getStatus()
                await MainActor.run {
                    guard let index = self.cards.firstIndex(where: { $0.id == id }) else { return }
                    guard self.runTokens[id] == token else { return }

                    switch status {
                    case .enabled:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Enabled",
                            status: .ok,
                            checkedAt: Date())
                    case .disabled:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Disabled",
                            status: .warning,
                            checkedAt: Date())
                    case .unknown:
                        self.cards[index] = self.updateSubtitleAndStatus(
                            self.cards[index],
                            subtitle: "Unknown",
                            status: .warning,
                            checkedAt: Date())
                    }
                    
                    self.runTokens[id] = nil
                }
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
