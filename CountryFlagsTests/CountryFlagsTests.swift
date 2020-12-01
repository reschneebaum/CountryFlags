//
//  CountryFlagsTests.swift
//  CountryFlagsTests
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import XCTest
@testable import CountryFlags

class CountryFlagsTests: XCTestCase {

    func testDecodingCountries() throws {
        let countries = Bundle.main.decode([Country].self, from: "test-countries.json")

        guard let first = countries?.first else {
            return XCTFail("error decoding first country")
        }
        var viewModel = CountryViewModel(country: first)

        XCTAssertEqual(viewModel.name, "Afghanistan")
        XCTAssertEqual(viewModel.capital, "Capital: Kabul")
        XCTAssertEqual(viewModel.cacheableImage.cacheKey, "AF")
        XCTAssertEqual(viewModel.cacheableImage.urlRequest?.url?.absoluteString, "https://countryflags.io/AF/flat/64.png")

        guard let last = countries?.last else {
            return XCTFail("error decoding last country")
        }
        viewModel = CountryViewModel(country: last)

        XCTAssertEqual(viewModel.name, "Antarctica")
        XCTAssertEqual(viewModel.capital, "")
        XCTAssertEqual(viewModel.cacheableImage.cacheKey, "AQ")
        XCTAssertEqual(viewModel.cacheableImage.urlRequest?.url?.absoluteString, "https://countryflags.io/AQ/flat/64.png")
    }

    func testImageCacheing() throws {
        let cache = ImageCache.shared
        cache.flush()

        let testImage = UIImage()
        let testKey = "test-key"

        let noImageExpectation = XCTestExpectation(description: "no image exists")
        cache.getCachedImage(for: testKey) { image in
            if image == nil {
                noImageExpectation.fulfill()
            }
        }
        wait(for: [noImageExpectation], timeout: 0.2)

        let imageExpectation = XCTestExpectation(description: "image exists")
        cache.writeImage(testImage, key: testKey)
        cache.getCachedImage(for: testKey) { image in
            if image != nil {
                imageExpectation.fulfill()
            }
        }
        wait(for: [imageExpectation], timeout: 0.2)

        let flushedExpectation = XCTestExpectation(description: "no image exists")
        cache.flush()
        cache.getCachedImage(for: testKey) { image in
            if image == nil {
                flushedExpectation.fulfill()
            }
        }
        wait(for: [flushedExpectation], timeout: 0.2)
    }

    func testRouter() throws {
        let getCountriesRequest = Router.getCountries.urlRequest
        XCTAssertEqual(getCountriesRequest?.url?.absoluteString, "https://restcountries.eu/rest/v2/all")
        XCTAssertEqual(getCountriesRequest?.httpMethod, "GET")

        let getImageRequest = Router.getFlag(code: "AF").urlRequest
        XCTAssertEqual(getImageRequest?.url?.absoluteString, "https://countryflags.io/AF/flat/64.png")
        XCTAssertEqual(getImageRequest?.httpMethod, "GET")
    }
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            XCTFail("Failed to load \(file) from bundle.")
            return nil
        }

        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            XCTFail("Failed to decode \(file) from bundle.")
            return nil
        }

        return loaded
    }
}
