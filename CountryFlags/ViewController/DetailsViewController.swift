//
//  DetailsViewController.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 12/1/20.
//

import UIKit

class DetailsViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let stackViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        static let stackViewSpacing: CGFloat = 12
        static let defaultFont = UIFont.systemFont(ofSize: 16)
        static let headerFont = UIFont.boldSystemFont(ofSize: 16)
    }

    // MARK: - Properties
    private(set) lazy var nameLabel = UILabel(forAutoLayoutWithFont: Constants.headerFont)
    private(set) lazy var capitalLabel = UILabel(forAutoLayoutWithFont: Constants.defaultFont)
    private(set) lazy var populationLabel = UILabel(forAutoLayoutWithFont: Constants.defaultFont)
    private(set) lazy var timezonesLabel = UILabel(forAutoLayoutWithFont: Constants.defaultFont, numberOfLines: 0)
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            forAutoLayoutWithArrangedSubviews: [nameLabel, capitalLabel, populationLabel, timezonesLabel],
            axis: .vertical,
            spacing: Constants.stackViewSpacing
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constants.stackViewInsets
        return stackView
    }()

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
}

// MARK: - Private Extension
private extension DetailsViewController {
    func configureViews() {
        view.addSubview(stackView)
        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
