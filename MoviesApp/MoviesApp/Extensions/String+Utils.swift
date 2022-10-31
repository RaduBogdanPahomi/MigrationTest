//
//  String+Utils.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 23.08.2022.
//

import Foundation

extension String {
    func getYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: self) else { return nil }

        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"

        return yearFormatter.string(from: date)
    }
    
    static func getFavoriteMoviesPath() -> URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentDirectory?.appendingPathComponent("FavoriteMovies.json")
    }
    
    func localizeString(string: String) -> String {
            let path = Bundle.main.path(forResource: string, ofType: "lproj")
            let bundle = Bundle(path: path!)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        }
}
