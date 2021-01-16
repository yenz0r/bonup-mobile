//
//  UIView+Gradient.swift
//  bonup-mobile
//
//  Created by yenz0redd on 23.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

extension UIView {
    func setupGradient(_ colors: [CGColor]) {

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.1)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        self.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = self.bounds
    }

    func setupBlur() {

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 0)
    }
}

