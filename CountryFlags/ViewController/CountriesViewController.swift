//
//  CountriesViewController.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/25/20.
//

import UIKit

final class CountriesViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let cellHeight: CGFloat = 80
    }

    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            CountryTableViewCell.self,
            forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier
        )
        tableView.rowHeight = Constants.cellHeight
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        return tableView
    }()
    private lazy var dataSource = CountriesDataSource(tappedHandler: {
        [weak self] viewModel in
        let detailsViewController = DetailsViewController()
        viewModel.configure(detailsViewController)
        self?.navigationController?.pushViewController(detailsViewController, animated: true)
    })

    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()

        dataSource.getCountries {
            [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Private Extension
private extension CountriesViewController {
    func configureViews() {
        title = "Countries".localized

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

