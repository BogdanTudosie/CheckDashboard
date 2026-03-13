//
//  Shell.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 12.3.2026.
//

import Foundation

enum Shell {
    static func run(_ launchPath: String, _ arguments: [String]) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let task = Process()
            task.executableURL = URL(fileURLWithPath: launchPath)
            task.arguments = arguments

            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe

            task.terminationHandler = { process in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(decoding: data, as: UTF8.self)
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                // Optional but good: treat non-zero exit as error
                if process.terminationStatus == 0 {
                    continuation.resume(returning: output)
                } else {
                    continuation.resume(throwing: ShellError.nonZeroExit(
                        code: process.terminationStatus,
                        output: output
                    ))
                }
            }

            do {
                try task.run()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    enum ShellError: Error, LocalizedError {
        case nonZeroExit(code: Int32, output: String)

        var errorDescription: String? {
            switch self {
            case .nonZeroExit(let code, let output):
                return "Command failed (exit \(code)): \(output)"
            }
        }
    }
}
