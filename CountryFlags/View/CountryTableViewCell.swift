//
//  CountryTableViewCell.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/27/20.
//

import UIKit

final class CountryTableViewCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        static let flagSize = CGSize(width: 96, height: 64)
        static let stackViewSpacing: CGFloat = 2
        static let stackViewInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    // MARK: - Properties
    private lazy var flagImageView: CacheableImageView = {
        let imageView = CacheableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .right
        return imageView
    }()
    private lazy var nameLabel = UILabel(forAutoLayoutWithFont: .systemFont(ofSize: 16), numberOfLines: 0)
    private lazy var capitalLabel = UILabel(forAutoLayoutWithFont: .systemFont(ofSize: 14))
    private lazy var labelStackView = UIStackView(
        forAutoLayoutWithArrangedSubviews: [nameLabel, capitalLabel],
        axis: .vertical,
        alignment: .leading
    )
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(
            forAutoLayoutWithArrangedSubviews: [labelStackView, flagImageView],
            alignment: .center,
            spacing: Constants.stackViewSpacing
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constants.stackViewInsets
        return stackView
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods
    func configure(with country: Country) {
        nameLabel.text = country.name
        capitalLabel.text = CountryViewModel.capitalString(for: country)
        flagImageView.setFlagImage(for: country)
    }

    func reset() {
        nameLabel.text = nil
        capitalLabel.text = nil
        flagImageView.image = nil
    }
}

// MARK: - Private Extension
private extension CountryTableViewCell {
    func configureViews() {
        contentView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            flagImageView.heightAnchor.constraint(equalToConstant: Constants.flagSize.height),
            flagImageView.widthAnchor.constraint(equalToConstant: Constants.flagSize.width)
        ])
    }
}
