//
//  FileVaultCheck.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 13.3.2026.
//
import Foundation

enum FileVaultCheckStatus {
    case on
    case off
    case encrypting
    case decrypting
    case unknown(String)
}

enum FileVaultCheck {
    static func getStatus() async -> FileVaultCheckStatus {
        do {
            let out = try await Shell.run("/usr/bin/fdesetup", ["status"])
            let s = out.lowercased()

            if s.contains("filevault is on") { return .on }
            if s.contains("filevault is off") { return .off }
            if s.contains("encryption in progress") { return .encrypting }
            if s.contains("decryption in progress") { return .decrypting }

            return .unknown(out)
        } catch {
            return .unknown(error.localizedDescription)
        }
    }
}
