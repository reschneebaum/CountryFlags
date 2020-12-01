//
//  DetailsViewController.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 12/1/20.
//

import UIKit

class DetailsViewController: UIViewController {
    // MARK: - Properties
    private(set) lazy var nameLabel = UILabel(forAutoLayoutWithFont: .systemFont(ofSize: 14))
    private(set) lazy var capitalLabel = UILabel(forAutoLayoutWithFont: .systemFont(ofSize: 14))
    private(set) lazy var populationLabel = UILabel(forAutoLayoutWithFont: .systemFont(ofSize: 14))
    private(set) lazy var timezonesLabel = UILabel(forAutoLayoutWithFont: .systemFont(ofSize: 14), numberOfLines: 0)
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            forAutoLayoutWithArrangedSubviews: [nameLabel, capitalLabel, populationLabel, timezonesLabel],
            axis: .vertical
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
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
