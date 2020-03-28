//
//  UITextField+Factory.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

extension UITextField {
    static func loginTextField(with placeholder: String?) -> UITextField {
        let textField = UITextField()

        textField.textAlignment = .center
        textField.layer.cornerRadius = 20.0
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor.pinkishGrey.withAlphaComponent(0.3)
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = .white80

        textField.attributedPlaceholder = NSAttributedString.with(
            title: placeholder ?? "",
            textColor: UIColor.white.withAlphaComponent(0.8),
            font: UIFont.avenirRoman(14)
        )

        textField.autocorrectionType = .no

        return textField
    }
}
