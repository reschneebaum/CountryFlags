//
//  CountriesDataSource.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import UIKit

/// A data source for `CountriesViewController`; handles fetching, storing, and displaying a list of countries.
final class CountriesDataSource: NSObject {
    // MARK: - Properties
    var countries: [CountryViewModel] = []
    private let networkService = NetworkService(imageCache: ImageCache())
    var tappedHandler: (CountryViewModel) -> Void

    // MARK: - Initializers
    init(tappedHandler: @escaping (CountryViewModel) -> Void) {
        self.tappedHandler = tappedHandler
    }

    // MARK: - Internal Methods
    func getCountries(completion: @escaping () -> Void) {
        networkService.getCountries {
            [weak self] result in
            guard let self = self,
                  case .success(let countries) = result else { return }
            self.countries = countries.map { CountryViewModel(country: $0, networkService: self.networkService) }
            completion()
        }
    }
}

// MARK: - UITableViewDataSource
extension CountriesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CountryTableViewCell.reuseIdentifier,
                for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        cell.reset()

        let viewModel = countries[indexPath.row]
        viewModel.configure(cell)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CountriesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = countries[indexPath.row]
        tappedHandler(viewModel)
    }
}
