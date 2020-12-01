//
//  Utils.swift
//  CountryFlags
//
//  Created by Rachel Schneebaum on 11/27/20.
//

import UIKit

public extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: Bundle.main, comment: "")
    }
}

public extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UIStackView {
    /**
     A convenience initializer for creating a `UIStackView` configured for auto layout
     (`translatesAutoresizingMaskIntoConstraints` set to `false`) with specified arranged subviews and optional axis,
     alignment, distribution, and spacing.

     - Parameters:
       - arrangedSubviews: The views to be arranged by the stack view.
       - axis: The axis along which the arranged views are laid out. Defaults to `.horizontal`.
       - alignment: The alignment of the arranged subviews perpendicular to the stack view’s axis. Defaults to `.fill`.
       - distribution: The distribution of the arranged views along the stack view’s axis. Defaults to `.fill`.
       - spacing: The distance in points between the adjacent edges of the stack view’s arranged views. Defaults to `0`.
     */
    convenience init(forAutoLayoutWithArrangedSubviews views: [UIView],
                     axis: NSLayoutConstraint.Axis = .horizontal,
                     alignment: UIStackView.Alignment = .fill,
                     distribution: UIStackView.Distribution = .fill,
                     spacing: CGFloat = 0) {
        self.init(arrangedSubviews: views)
        translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}

public extension UILabel {
    /**
     A convenience initializer for creating a `UILabel` configured for auto layout
     (`translatesAutoresizingMaskIntoConstraints` set to `false`) with a specified font as well as optional text, text
     color, and text alignment.

     - Parameters:
       - font: The font to use to display the text.
       - text: The text to be displayed by the label.
       - accessibilityLabel: The text to be read by VoiceOver. (If nil, the label's `text` value is used.)
       - textColor: The color of the text.
       - textAlignment: The technique to use for aligning the text.
     */
    convenience init(forAutoLayoutWithFont font: UIFont,
                     text: String? = nil,
                     textColor: UIColor = .black,
                     textAlignment: NSTextAlignment = .natural,
                     numberOfLines: Int = 1) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
