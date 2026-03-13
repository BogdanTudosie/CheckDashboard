//
//  CheckKind.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 13.3.2026.
//

import Foundation

enum CheckKind: String, CaseIterable, Hashable, Identifiable {
    case firewall
    case filevault
    case updates
    case gatekeeper

    var id: String { rawValue }
}
