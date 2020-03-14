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
        case whiteButton, yellowButton
    }

    static func systemButton(for type: ColoredButtonType, title: String) -> UIButton {
        let button = UIButton(type: .system)

        button.layer.cornerRadius = 20.0
        button.clipsToBounds = true

        switch type {
        case .yellowButton:
            button.setAttributedTitle(
                NSAttributedString.with(
                    title: "ui_sign_in_title".localized,
                    textColor: UIColor.white,
                    font: UIFont.avenirRoman(14)
                ),
                for: .normal
            )
            button.backgroundColor = UIColor.goldenYellow
        case .whiteButton:
            button.setAttributedTitle(
                NSAttributedString.with(
                    title: "ui_sign_up_title".localized,
                    textColor: UIColor.goldenYellow,
                    font: UIFont.avenirRoman(14)
                ),
                for: .normal
            )
            button.backgroundColor = .white
        }

        return button
    }
}
