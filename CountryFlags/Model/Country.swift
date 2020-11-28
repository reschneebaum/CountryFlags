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

struct CacheableImage {
    var cacheKey: String
    var urlRequest: URLRequest?

    init(country: Country) {
        self.cacheKey = country.alpha2Code
        self.urlRequest = Router.getFlag(code: country.alpha2Code).urlRequest
    }
}
