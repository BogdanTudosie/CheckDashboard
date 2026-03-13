//
//  AutoUpdatesCheck.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 13.3.2026.
//

import Foundation

enum AutoUpdatesStatus {
    case enabled
    case disabled
    case unknown(String)
}

enum AutoUpdatesCheck {
    static func getStatus() async -> AutoUpdatesStatus {
        do {
            let out = try await Shell.run("/usr/bin/softwareupdate", ["--schedule"])
            let s = out.lowercased()
            
            if s.contains("turned on") || s.contains("is on") {
                return .enabled
            }
            if s.contains("turned off") || s.contains("is off") {
                return .disabled
            }
            
            return .unknown(out)
        } catch {
            return .unknown(error.localizedDescription)
        }
    }
}
