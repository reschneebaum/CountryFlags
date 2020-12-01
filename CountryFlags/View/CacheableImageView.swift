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

    /// Confirms that the fetched image is associated with the given view model —- e.g., if this image view is
    /// a subview of a `UITableViewCell` that has been reused since the image download began.
    func shouldDisplayImage(with viewModel: CountryViewModel) -> Bool {
        cacheableImage?.cacheKey == viewModel.cacheableImage.cacheKey
    }
}
