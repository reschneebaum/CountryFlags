//
//  CacheableImageView.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/27/20.
//

import UIKit

final class CacheableImageView: UIImageView {
    // MARK: - Properties
    private var cacheableImage: CacheableImage?
    private var cancelCurrentTaskHandler: (() -> Void)?

    // MARK: - Internal Methods
    func setFlagImage(for country: Country) {
        cacheableImage = country.cacheableFlag
        ImageCache.shared.getCachedImage(for: country.cacheableFlag.cacheKey) {
            [weak self] cachedImage in
            guard let self = self else { return }
            if let image = cachedImage,
               self.shouldDisplayImage(for: country) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                self.cancelCurrentTaskHandler = NetworkService.shared.downloadFlagImage(for: country) {
                    [weak self] result in
                    guard let self = self,
                        case .success(let image) = result,
                        self.shouldDisplayImage(for: country) else { return }
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }

    func cancelCurrentDownloadTask() {
        cancelCurrentTaskHandler?()
    }

    func shouldDisplayImage(for country: Country) -> Bool {
        cacheableImage?.cacheKey == country.cacheableFlag.cacheKey
    }
}
