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
    private var cache = NSCache<NSString, UIImage>()
    private var concurrentImageQueue = DispatchQueue(
        label: "com.reschneebaum.ImageQueue",
        qos: .userInteractive,
        attributes: .concurrent
    )

    // MARK: - Initializers
    private init() {
        flush()

        // Register for memory warning notifications; when received, flush entire memory cache.
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main) { _ in
                self.flush()
        }
    }

    // MARK: - Internal Methods
    func getCachedImage(for key: String, completion: @escaping (UIImage?) -> Void) {
        concurrentImageQueue.sync {
            let image = cache.object(forKey: key as NSString)
            completion(image)
        }
    }

    func writeImage(_ image: UIImage, key: String) {
        concurrentImageQueue.sync(flags: .barrier) {
            cache.setObject(image, forKey: key as NSString)
        }
    }

    func flush() {
        concurrentImageQueue.sync(flags: .barrier) {
            cache.removeAllObjects()
        }
    }
}
