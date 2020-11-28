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
        static let flagHeight: CGFloat = 64
        static let stackViewSpacing: CGFloat = 12
        static let leftInset: CGFloat = 16
    }

    // MARK: - Properties
    private lazy var flagImageView: CacheableImageView = {
        let imageView = CacheableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .right
        return imageView
    }()
    private lazy var nameLabel = UILabel(forAutoLayoutWithFont: .systemFont(ofSize: 16))
    private lazy var capitalLabel = UILabel(forAutoLayoutWithFont: .systemFont(ofSize: 14))
    private lazy var labelStackView = UIStackView(
        forAutoLayoutWithArrangedSubviews: [nameLabel, capitalLabel],
        axis: .vertical
    )
    private lazy var contentStackView = UIStackView(
        forAutoLayoutWithArrangedSubviews: [flagImageView, labelStackView],
        alignment: .center,
        spacing: Constants.stackViewSpacing
    )

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
        capitalLabel.text = country.capital
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
            contentStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.leftInset),
            flagImageView.heightAnchor.constraint(equalToConstant: Constants.flagHeight)
        ])
    }
}
