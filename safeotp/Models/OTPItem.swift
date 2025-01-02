//
//  OTPItem.swift
//  safeotp
//
//  Created by Rama Adi Nugraha on 02/01/25.
//

import Foundation


struct OTPItem: Sendable, Identifiable, Equatable {
    let id = UUID()
    let issuer: String
    let secret: String
    
    var otp: String?
    var remainingTime: Int?
}
