//
//  OTP.swift
//  safeotp
//
//  Created by Rama Adi Nugraha on 02/01/25.
//

import Foundation
import Dependencies
import DependenciesMacros
import SwiftOTP

@DependencyClient
struct OTPClient: Sendable {
    
    /// Stream that emits `(currentCode, secondsRemaining)` every second.
    var stream: @Sendable (String) -> AsyncStream<(String, Int)> = { _ in
            .finished
    }
}

extension OTPClient: DependencyKey {
    static let liveValue: OTPClient = OTPClient(
        stream: { secret in
            return AsyncStream { continuation in
                @Dependency(\.date.now) var date
                @Dependency(\.continuousClock) var clock
                
                
                /// Create a TOTP instance for the given secret.
                let base32 = base32DecodeToData(secret)!
                let totp = TOTP(secret: base32, digits: 6, timeInterval: 30)
                
                /// Start a Task that ticks every second.
                let task = Task {
                    while !Task.isCancelled {
                        guard let code = totp?.generate(time: date) else {
                            // If TOTP generation fails, finish the stream.
                            continuation.finish()
                            return
                        }
                        
                        // Calculate how many seconds remain until the TOTP code changes.
                        let now = date.timeIntervalSince1970
                        let step = floor(now / 30)
                        let nextStep = step + 1
                        let nextCodeTime = nextStep * 30
                        let remaining = Int(nextCodeTime - now)
                        
                        // Emit the current code and how many seconds remain.
                        continuation.yield((code, max(0, remaining)))
                        
                        // Sleep for 1 second before emitting again.
                        try await clock.sleep(for: .seconds(1))
                    }
                }
                
                /// When the AsyncStream is canceled or finished, stop our Task.
                continuation.onTermination = { _ in
                    task.cancel()
                }
            }
        }
    )
}

extension DependencyValues {
    var otpClient: OTPClient {
        get { self[OTPClient.self] }
        set { self[OTPClient.self] = newValue }
    }
}
