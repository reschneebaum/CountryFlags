//
//  CountryViewModel.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import Foundation

class CountryViewModel {
    // MARK: - Properties
    var name: String {
        country.name
    }
    var capitalDisplayString: String {
        !country.capital.isEmpty ? String(format: "CapitalFormat".localized, country.capital) : ""
    }
    var populationDisplayString: String {
        String(format: "PopulationFormat".localized, "\(country.population)")
    }
    var timezonesDisplayString: String {
        String(format: "TimezonesFormat".localized, country.timezones.joined(separator: ", "))
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
            [weak self, weak imageView] cachedImage in
            guard let self = self else { return }
            if let image = cachedImage,
               imageView?.shouldDisplayImage(self.cacheableImage) == true {
                DispatchQueue.main.async {
                    imageView?.image = image
                }
            } else {
                self.networkService.downloadImage(for: self) {
                    [weak self, weak imageView] result in
                    guard let self = self,
                          case .success(let image) = result,
                          imageView?.shouldDisplayImage(self.cacheableImage) == true else { return }
                    DispatchQueue.main.async {
                        imageView?.image = image
                    }
                }
            }
        }
    }

    func configure(_ viewController: DetailsViewController) {
        viewController.title = name
        viewController.nameLabel.text = name
        viewController.capitalLabel.text = capitalDisplayString
        viewController.populationLabel.text = populationDisplayString
        viewController.timezonesLabel.text = timezonesDisplayString
    }
}

struct Country: Codable {
    fileprivate var name: String
    fileprivate var capital: String
    fileprivate var alpha2Code: String
    fileprivate var population: Int
    fileprivate var timezones: [String]
}

/// Holds a url request for downloading a particular image and a key for caching/retrieving that image.
struct CacheableImage {
    var cacheKey: String
    var urlRequest: URLRequest?

    init(country: Country) {
        cacheKey = country.alpha2Code
        urlRequest = Router.getFlag(code: country.alpha2Code).urlRequest
    }
}
