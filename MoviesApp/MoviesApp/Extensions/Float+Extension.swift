//
//  Float+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 20.10.2022.
//

import Foundation

extension Float {
    func round(toNearest nearest: Float) -> Float {
        let nominator = 1 / nearest
        let numberToRound = self * nominator
        return numberToRound.rounded() / nominator
    }
}
