//
//  SystemSettings.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 13.3.2026.
//

import Foundation
import AppKit

enum SystemSettings {
    static func openFirewall() {
        let candidates = networkPaneIdentifiers()
        let urls = candidates.map { "x-apple.systempreferences:\($0)" }
        
        if openFirstValid(urls: urls) {
            return
        }
        
        // Fallback: open System Settings main screen.
        _ = openFirstValid(urls: ["x-apple.systempreferences:"])
    }
    
    static func openFileVault() {
        let candidates = fileVaultIdentifiers()
        let urls = candidates.map { "x-apple.systempreferences:\($0)" }

        if openFirstValid(urls: urls) {
            return
        }

        // Fallback: open System Settings main screen.
        _ = openFirstValid(urls: ["x-apple.systempreferences:"])
    }
    
    private static func openFirstValid(urls: [String]) -> Bool {
        for urlString in urls {
            if let url = URL(string: urlString), NSWorkspace.shared.open(url) {
                return true
            }
        }
        return false
    }
    
    private static func networkPaneIdentifiers() -> [String] {
        let sidebarPath = "/System/Applications/System Settings.app/Contents/Resources/Sidebar.plist"
        let url = URL(fileURLWithPath: sidebarPath)
        
        guard
            let data = try? Data(contentsOf: url),
            let raw = try? PropertyListSerialization.propertyList(from: data, format: nil),
            let array = raw as? [[String: Any]]
        else {
            return ["com.apple.Network-Settings.extension"]
        }
        
        var ids: [String] = []
        for section in array {
            if let content = section["content"] as? [String] {
                ids.append(contentsOf: content)
            }
        }
        
        let preferred = ids.filter { $0.localizedCaseInsensitiveContains("Network-Settings") }
        if !preferred.isEmpty { return preferred }
        
        let fallback = ids.filter { $0.localizedCaseInsensitiveContains("Network") }
        return fallback.isEmpty ? ["com.apple.Network-Settings.extension"] : fallback
    }
    
    private static func fileVaultIdentifiers() -> [String] {
        let sidebarPath = "/System/Applications/System Settings.app/Contents/Resources/Sidebar.plist"
        let url = URL(fileURLWithPath: sidebarPath)
        
        guard
            let data = try? Data(contentsOf: url),
            let raw = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
            let array = raw as? [[String: Any]]
        else {
            return []
        }
        
        var ids: [String] = []
        for section in array {
            if let content = section["content"] as? [String] {
                ids.append(contentsOf: content)
            }
        }
        
        let preferred = ids.filter { $0.localizedCaseInsensitiveContains("PrivacySecurity") }
        if !preferred.isEmpty { return preferred }

        let fallback = ids.filter { $0.localizedCaseInsensitiveContains("Privacy") }
        return fallback
    }
}
