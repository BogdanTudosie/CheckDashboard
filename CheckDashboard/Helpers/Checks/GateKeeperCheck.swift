//
//  GateKeeperCheck.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 13.3.2026.
//

import Foundation

enum GatekeeperStatus {
    case enabled
    case disabled
    case unknown(String)
}

enum GatekeeperCheck {
    static func getStatus() async -> GatekeeperStatus {
        do {
            let out = try await Shell.run("/usr/sbin/spctl", ["--status"])
            let s = out.lowercased()

            if s.contains("assessments enabled") { return .enabled }
            if s.contains("assessments disabled") { return .disabled }

            return .unknown(out)
        } catch {
            return .unknown(error.localizedDescription)
        }
    }
}
