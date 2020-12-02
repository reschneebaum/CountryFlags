//
//  CountryFlagsTests.swift
//  CountryFlagsTests
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import XCTest
@testable import CountryFlags

class CountryFlagsTests: XCTestCase {
    let testNetworkService = NetworkService(
        imageCache: ImageCache(imageQueueLabel: "test-image-queue"),
        downloadQueueLabel: "test-download-queue"
    )

    func testDecodingCountries() throws {
        let countries = Bundle(for: CountryFlagsTests.self).decode([Country].self, from: "test-countries.json")

        guard let first = countries?.first else {
            return XCTFail("error decoding first country")
        }
        var systemUnderTest = CountryViewModel(country: first, networkService: testNetworkService)

        XCTAssertEqual(systemUnderTest.name, "Afghanistan")
        XCTAssertEqual(systemUnderTest.capitalDisplayString, "Capital: Kabul")
        XCTAssertEqual(systemUnderTest.timezonesDisplayString, "Timezones: UTC+04:30")
        XCTAssertEqual(systemUnderTest.populationDisplayString, "Population: 27657145")
        XCTAssertEqual(systemUnderTest.cacheableImage.cacheKey, "AF")
        XCTAssertEqual(systemUnderTest.cacheableImage.urlRequest?.url?.absoluteString, "https://countryflags.io/AF/flat/64.png")

        guard let last = countries?.last else {
            return XCTFail("error decoding last country")
        }
        systemUnderTest = CountryViewModel(country: last, networkService: testNetworkService)

        XCTAssertEqual(systemUnderTest.name, "Antarctica")
        XCTAssertEqual(systemUnderTest.capitalDisplayString, "")
        XCTAssertEqual(systemUnderTest.timezonesDisplayString, "Timezones: UTC-03:00, UTC+03:00, UTC+05:00, UTC+06:00, UTC+07:00, UTC+08:00, UTC+10:00, UTC+12:00")
        XCTAssertEqual(systemUnderTest.populationDisplayString, "Population: 1000")
        XCTAssertEqual(systemUnderTest.cacheableImage.cacheKey, "AQ")
        XCTAssertEqual(systemUnderTest.cacheableImage.urlRequest?.url?.absoluteString, "https://countryflags.io/AQ/flat/64.png")
    }

    func testImageCaching() throws {
        let cache = ImageCache(imageQueueLabel: "test-image-queue")
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
        XCTAssertEqual(getCountriesRequest?.url?.absoluteString, "https://restcountries.eu/rest/v2/all?fields=name;capital;alpha2Code;timezones;population")
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
