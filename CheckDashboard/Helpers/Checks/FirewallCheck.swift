//
//  FirewallCheck.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 12.3.2026.
//

import Foundation

enum FirewallStatus {
    case enabled
    case disabled
    case unknown(String)
}

enum FirewallCheck {
    static func readFirewallStatus() async -> FirewallStatus {
        do {
            let out = try await Shell.run("/usr/libexec/ApplicationFirewall/socketfilterfw",
                                          ["--getglobalstate"])
            
            if let state = parseFirewallStatus(out) {
                switch state {
                case 0: return .disabled
                case 1: return .enabled
                case 2: return .enabled
                default: return .unknown(out)
                }
            } else {
                return .unknown(out)
            }
        } catch {
            return .unknown(error.localizedDescription)
        }
    }
    
    private static func parseFirewallStatus(_ out: String) -> Int? {
        let pattern = /State\s*=\s*(\d+)/
        guard let match = out.firstMatch(of: pattern) else { return nil }
        return Int(match.1)
    }
}
