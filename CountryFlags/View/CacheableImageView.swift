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

    /// Confirms that the fetched image is associated with this image view —- e.g., if the image view is
    /// a subview of a `UITableViewCell` that has been reused since the image download began.
    func shouldDisplayImage(_ cacheableImage: CacheableImage) -> Bool {
        self.cacheableImage?.cacheKey == cacheableImage.cacheKey
    }
}
