//
//  Persistence.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 9.3.2026.
//

import Foundation

enum Persist {
    static func encodeStringArray(_ value: [String]) -> Data {
        (try? JSONEncoder().encode(value)) ?? Data()
    }
    
    static func decodeStringArray(_ data: Data) -> [String] {
        (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}
