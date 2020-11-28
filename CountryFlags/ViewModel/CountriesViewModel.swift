//
//  CountriesViewModel.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import UIKit

class CountriesViewModel: NSObject {
    // MARK: - Properties
    var countries: [Country] = []

    // MARK: - Internal Methods
    func updateCountries(completion: @escaping () -> Void) {
        NetworkService.shared.getCountries {
            [weak self] result in
            guard let self = self,
                  case .success(let countries) = result else { return }
            self.countries = countries
            completion()
        }
    }
}

// MARK: - UITableViewDataSource
extension CountriesViewModel: UITableViewDataSource {
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

        let country = countries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CountriesViewModel: UITableViewDelegate {

}
