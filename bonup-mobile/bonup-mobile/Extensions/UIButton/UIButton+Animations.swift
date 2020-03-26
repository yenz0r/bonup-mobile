//
//  UIButton+Animations.swift
//  bonup-mobile
//
//  Created by yenz0redd on 27.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

extension UIButton {
    func shake() {
        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.1,
                    animations: {
                        self.frame.origin.x += 5
                    }
                )

                UIView.addKeyframe(
                    withRelativeStartTime: 0.1,
                    relativeDuration: 0.1,
                    animations: {
                        self.frame.origin.x -= 10
                    }
                )

                UIView.addKeyframe(
                    withRelativeStartTime: 0.2,
                    relativeDuration: 0.1,
                    animations: {
                        self.frame.origin.x += 5
                    }
                )
            },
            completion: nil
        )
    }
}
