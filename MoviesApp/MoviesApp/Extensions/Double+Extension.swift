//
//  Double+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 24.08.2022.
//

import Foundation

extension Double {
    func limitNumberOfDigits() -> Double {
        let limitedNumber = Double((self * 10).rounded() / 10)
        return limitedNumber
   }
    
    func minutesToHours(_ minutes: Double) -> (hours: Double, leftMinutes: Double) {
        return (minutes/60, (minutes.truncatingRemainder(dividingBy: 60)))
    }
}
