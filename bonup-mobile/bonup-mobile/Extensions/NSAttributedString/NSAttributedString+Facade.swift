//
//  NSAttributedString+Facade.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static func with(title: String, textColor: UIColor, font: UIFont) -> NSAttributedString {
        return NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: textColor,
                .font: font
            ]
        )
    }
}

