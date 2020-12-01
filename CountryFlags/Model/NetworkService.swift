//
//  NetworkService.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/27/20.
//

import UIKit

enum NetworkError: Error {
    case invalidURLRequest, dataParsingFailed
}

final class NetworkService {
    // MARK: - Properties
    static let shared = NetworkService()
    /// Image download tasks that have not yet completed
    private var imageDownloadTasks: [String: URLSessionTask] = [:]
    /// Thread-safe queue for adding new image download tasks and removing completed tasks
    private var downloadTaskQueue = DispatchQueue(
        label: "com.reschneebaum.DataTaskQueue",
        qos: .background,
        attributes: .concurrent
    )

    // MARK: - Initializers
    private init() {}

    // MARK: - Internal Methods
    func getCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let urlRequest = Router.getCountries.urlRequest else {
            return completion(.failure(NetworkError.invalidURLRequest))
        }

        let dataTask = URLSession(configuration: .default).dataTask(with: urlRequest) {
            (data, _, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? NetworkError.dataParsingFailed))
                }
                return
            }

            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(countries))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        dataTask.resume()
    }

    func downloadImage(for viewModel: CountryViewModel, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let urlRequest = viewModel.cacheableImage.urlRequest else {
            return completion(.failure(NetworkError.invalidURLRequest))
        }

        let cacheKey = viewModel.cacheableImage.cacheKey

        // Check if this task has already started; if so, don't add a repeat task to the queue.
        if let _ = queuedTask(for: cacheKey) { return }

        // If there's no existing task for this urlRequest, create one.
        let dataTask = URLSession(configuration: .default).dataTask(with: urlRequest) {
            [weak self] (data, _, error) in
            guard let self = self else { return }
            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? NetworkError.dataParsingFailed))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(image))
            }

            // Add the downloaded image to the cache and remove this completed task from the queue.
            ImageCache.shared.writeImage(image, key: cacheKey)
            self.removeQueuedTask(for: cacheKey)
        }

        addTaskToQueue(dataTask, for: cacheKey)
        dataTask.resume()
    }
}

// MARK: - Private Extension
private extension NetworkService {
    /// Given a key, returns an associated `URLSessionTask` from the queue, if one exists.
    /// **Use this thread-safe method rather than accessing the queue directly.**
    ///
    /// - Parameter key: the `String` key associated with the desired task
    /// - Returns: the queued `URLSessionTask` associated with the provided key
    func queuedTask(for key: String) -> URLSessionTask? {
        downloadTaskQueue.sync {
            return imageDownloadTasks[key]
        }
    }

    /// Adds the provided `URLSessionTask` to the queue associated with the provided key.
    /// **Use this thread-safe method rather than accessing the queue directly.**
    ///
    /// - Parameter task: the `URLSessionTask` to be added to the queue
    /// - Parameter key: the `String` key associated with the given task
    func addTaskToQueue(_ task: URLSessionTask, for key: String) {
        downloadTaskQueue.sync(flags: .barrier) {
            imageDownloadTasks[key] = task
        }
    }

    /// Removes the `URLSessionTask` associated with the provided key from the queue.
    /// **Use this thread-safe method rather than accessing the queue directly.**
    ///
    /// - Parameter key: the `String` key associated with the task to be removed
    func removeQueuedTask(for key: String) {
        _ = downloadTaskQueue.sync(flags: .barrier) {
            imageDownloadTasks.removeValue(forKey: key)
        }
    }
}
