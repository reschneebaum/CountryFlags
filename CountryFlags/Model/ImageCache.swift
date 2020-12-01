//
//  ImageCache.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/27/20.
//

import UIKit

final class ImageCache {
    // MARK: - Properties
    static let shared = ImageCache()
    /// A cache for all downloaded flag images
    private var cache = NSCache<NSString, UIImage>()
    /// Thread-safe queue for writing new images to the cache or removing cached images
    private var concurrentImageQueue = DispatchQueue(
        label: "com.reschneebaum.ImageQueue",
        qos: .userInteractive,
        attributes: .concurrent
    )

    // MARK: - Initializers
    private init() {
        flush()

        // When a memory warning notification is received, flush entire cache.
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main) { _ in
                self.flush()
        }
    }

    // MARK: - Internal Methods
    /// Returns a cached `UIImage` associated with the provided `String` key, if one exists.
    /// **Use this thread-safe method rather than accessing the cache directly.**
    func getCachedImage(for key: String, completion: @escaping (UIImage?) -> Void) {
        concurrentImageQueue.sync {
            let image = cache.object(forKey: key as NSString)
            completion(image)
        }
    }

    /// Writes the provided `UIImage` to the cache, associated with the provided `String`.
    /// **Use this thread-safe method rather than accessing the cache directly.**
    func writeImage(_ image: UIImage, key: String) {
        concurrentImageQueue.sync(flags: .barrier) {
            cache.setObject(image, forKey: key as NSString)
        }
    }

    /// Clears the entire image cache.
    /// **Use this thread-safe method rather than accessing the cache directly.**
    func flush() {
        concurrentImageQueue.sync(flags: .barrier) {
            cache.removeAllObjects()
        }
    }
}
