//
//  UIButton+Factory.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

extension UIButton {
    enum ColoredButtonType {
        case whiteButton
        case emptyBackgroundButton(contentColor: UIColor)
        case onlyText
    }

    static func systemButton(for type: ColoredButtonType, title: String) -> UIButton {
        let button = UIButton(type: .system)

        button.layer.cornerRadius = 20.0
        button.clipsToBounds = true

        switch type {
        case .emptyBackgroundButton(let contentColor):
            button.setAttributedTitle(
                NSAttributedString.with(
                    title: title,
                    textColor: contentColor,
                    font: UIFont.avenirRoman(14)
                ),
                for: .normal
            )
            button.backgroundColor = .clear
            button.layer.borderWidth = 1
            button.layer.borderColor = contentColor.cgColor
        case .whiteButton:
            button.setAttributedTitle(
                NSAttributedString.with(
                    title: title,
                    textColor: UIColor.purpleLite,
                    font: UIFont.avenirRoman(14)
                ),
                for: .normal
            )
            button.backgroundColor = .white
        case .onlyText:
            button.setAttributedTitle(
                NSAttributedString.with(
                    title: title,
                    textColor: UIColor.purpleLite,
                    font: UIFont.avenirRoman(14)
                ),
                for: .normal
            )
            button.backgroundColor = .clear
        }

        return button
    }

    func configureCircleButton(with image: UIImage?) {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10

        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(image, for: .normal)
    }
}
