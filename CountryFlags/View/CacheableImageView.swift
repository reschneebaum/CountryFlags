//
//  CacheableImageView.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/27/20.
//

import UIKit

final class CacheableImageView: UIImageView {
    // MARK: - Properties
    var cacheableImage: CacheableImage?
    var cancelCurrentTaskCompletion: (() -> Void)?

    // MARK: - Internal Methods
    func setFlagImage(for country: Country) {
        cacheableImage = CacheableImage(country: country)
        ImageCache.shared.getCachedImage(for: cacheableImage!.cacheKey) {
            [weak self] cachedImage in
            guard let self = self else { return }
            if let image = cachedImage,
               self.cacheableImage?.cacheKey == country.alpha2Code {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                self.cancelCurrentTaskCompletion = NetworkService.shared.downloadFlagImage(for: country) {
                    [weak self] result in
                    guard case .success(let image) = result,
                          self?.cacheableImage?.cacheKey == country.alpha2Code else { return }
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

    func cancelCurrentDownloadTask() {
        cancelCurrentTaskCompletion?()
    }
}
