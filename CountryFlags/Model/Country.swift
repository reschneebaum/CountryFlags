//
//  Country.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import UIKit

struct Country: Codable {
    var name: String
    var capital: String
    var alpha2Code: String
}

extension Country {
    var capitalDisplayString: String {
        !capital.isEmpty ? String(format: "CapitalFormat".localized, capital) : ""
    }

    var cacheableFlag: CacheableImage {
        CacheableImage(country: self)
    }
}

struct CacheableImage {
    var cacheKey: String
    var urlRequest: URLRequest?

    init(country: Country) {
        self.cacheKey = country.alpha2Code
        self.urlRequest = Router.getFlag(code: country.alpha2Code).urlRequest
    }
}
