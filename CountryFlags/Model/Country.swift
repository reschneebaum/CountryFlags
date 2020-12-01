//
//  Country.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import Foundation

struct Country: Codable {
    fileprivate var name: String
    fileprivate var capital: String
    fileprivate var alpha2Code: String
}

struct CountryViewModel {
    var name: String {
        country.name
    }
    var capital: String {
        !country.capital.isEmpty ? String(format: "CapitalFormat".localized, country.capital) : ""
    }
    var cacheableImage: CacheableImage {
        CacheableImage(country: country)
    }
    private var country: Country

    init(country: Country) {
        self.country = country
    }
}

/// Holds a url request for downloading a particular image and a key for cacheing/retriving that image.
struct CacheableImage {
    var cacheKey: String
    var urlRequest: URLRequest?

    init(country: Country) {
        cacheKey = country.alpha2Code
        urlRequest = Router.getFlag(code: country.alpha2Code).urlRequest
    }
}
