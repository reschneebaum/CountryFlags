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

    // MARK: - Internal Methods
    func setImage(with viewModel: CountryViewModel) {
        cacheableImage = viewModel.cacheableImage
        ImageCache.shared.getCachedImage(for: viewModel.cacheableImage.cacheKey) {
            [weak self] cachedImage in
            guard let self = self else { return }
            if let image = cachedImage,
               self.shouldDisplayImage(with: viewModel) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                NetworkService.shared.downloadImage(for: viewModel) {
                    [weak self] result in
                    guard let self = self,
                        case .success(let image) = result,
                        self.shouldDisplayImage(with: viewModel) else { return }
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }

    /// Confirms that the fetched image is associated with the given view model —- e.g., if this image view is
    /// a subview of a `UITableViewCell` that has been reused since the image download began.
    func shouldDisplayImage(with viewModel: CountryViewModel) -> Bool {
        cacheableImage?.cacheKey == viewModel.cacheableImage.cacheKey
    }
}
