//
//  Router.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import Foundation

enum Router {
    case getCountries, getFlag(code: String)

    private var scheme: String {
        return "https"
    }

    private var host: String {
        switch self {
        case .getCountries:
            return "restcountries.eu"
        case .getFlag(_):
            return "countryflags.io"
        }
    }

    private var path: String {
        switch self {
        case .getCountries:
            return "/rest/v2/all"
        case .getFlag(code: let code):
            return "/\(code)/flat/64.png"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .getCountries:
            return [URLQueryItem(name: "fields", value: "name;capital;alpha2Code;timezones;population")]
        default:
            return nil
        }
    }

    private var method: String {
        return "GET"
    }

    var urlRequest: URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method

        return urlRequest
    }
}
