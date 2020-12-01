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
    // MARK: - Properties
    var name: String {
        country.name
    }
    var capitalDisplayString: String {
        !country.capital.isEmpty ? String(format: "CapitalFormat".localized, country.capital) : ""
    }
    var cacheableImage: CacheableImage {
        CacheableImage(country: country)
    }
    private let country: Country
    private let networkService: NetworkService

    // MARK: - Initializers
    init(country: Country, networkService: NetworkService) {
        self.country = country
        self.networkService = networkService
    }

    // MARK: - Internal Methods
    func configure(_ cell: CountryTableViewCell) {
        cell.nameLabel.text = name
        cell.capitalLabel.text = capitalDisplayString
        setImage(to: cell.flagImageView)
    }

    func setImage(to imageView: CacheableImageView) {
        imageView.cacheableImage = cacheableImage
        networkService.imageCache.getCachedImage(for: cacheableImage.cacheKey) {
            [weak imageView] cachedImage in
            if let image = cachedImage,
               imageView?.shouldDisplayImage(with: self) == true {
                DispatchQueue.main.async {
                    imageView?.image = image
                }
            } else {
                self.networkService.downloadImage(for: self) {
                    [weak imageView] result in
                    guard case .success(let image) = result,
                        imageView?.shouldDisplayImage(with: self) == true else { return }
                    DispatchQueue.main.async {
                        imageView?.image = image
                    }
                }
            }
        }
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
