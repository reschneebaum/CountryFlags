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
    private var imageDownloadTasks: [URLRequest: URLSessionDataTask] = [:]
    private var dataTaskQueue = DispatchQueue(
        label: "com.reschneebaum.DataTaskQueue",
        qos: .background,
        attributes: .concurrent
    )

    // MARK: - Initializers
    private init() {}

    // MARK: - Internal Methods
    func getCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let urlRequest = Router.getCountries.urlRequest else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidURLRequest))
            }
            return
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

    @discardableResult func downloadFlagImage(for country: Country, completion: @escaping (Result<UIImage?, Error>) -> Void) -> (() -> Void)? {
        guard let urlRequest = Router.getFlag(code: country.alpha2Code).urlRequest else {
            completion(.failure(NetworkError.invalidURLRequest))
            return nil
        }

        // Check for an existing task
        if let _ = dataTask(for: urlRequest) {
            return nil
        }

        let dataTask = URLSession(configuration: .default).dataTask(with: urlRequest) {
            [weak self] (data, _, error) in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? NetworkError.dataParsingFailed))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(image))
            }

            ImageCache.shared.writeImage(image, key: country.cacheableFlag.cacheKey)
            _ = self.dataTaskQueue.sync(flags: .barrier) {
                self.imageDownloadTasks.removeValue(forKey: urlRequest)
            }
        }

        dataTaskQueue.sync(flags: .barrier) {
            imageDownloadTasks[urlRequest] = dataTask
        }
        dataTask.resume()

        return {
            [weak dataTask] in
            dataTask?.cancel()
        }
    }
}

// MARK: - Private Extension
private extension NetworkService {
    func dataTask(for request: URLRequest) -> URLSessionTask? {
        dataTaskQueue.sync {
            return imageDownloadTasks[request]
        }
    }
}
