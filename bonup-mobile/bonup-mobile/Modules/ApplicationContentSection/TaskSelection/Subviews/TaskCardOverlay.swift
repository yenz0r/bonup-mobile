//
//  TaskCardOverlay.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class TaskCardOverlay: UIView {

    static func left() -> UIView {
        let overlay = UIView()
        let leftTextView = SampleOverlayLabelView(withTitle: "NOPE",
                                                  color: .sampleRed,
                                                  rotation: CGFloat.pi/10)
        overlay.addSubview(leftTextView)

        leftTextView.snp.makeConstraints { make in
            make.top.equalTo(overlay).offset(30.0)
            make.trailing.equalTo(overlay).offset(14.0)
        }

        return overlay
    }

    static func right() -> UIView {
        let overlay = UIView()
        let rightTextView = SampleOverlayLabelView(withTitle: "LIKE",
                                                   color: .sampleGreen,
                                                   rotation: -CGFloat.pi/10)
        overlay.addSubview(rightTextView)

        rightTextView.snp.makeConstraints { make in
            make.top.equalTo(overlay).offset(26)
            make.leading.equalTo(overlay).offset(-14)
        }

        return overlay
    }
}

private class SampleOverlayLabelView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    init(withTitle title: String, color: UIColor, rotation: CGFloat) {
        super.init(frame: CGRect.zero)
        layer.borderColor = color.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 4
        transform = CGAffineTransform(rotationAngle: rotation)

        addSubview(titleLabel)
        titleLabel.textColor = color
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: NSAttributedString.Key.overlayAttributes)

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10.0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private extension NSAttributedString.Key {

    static var overlayAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 42)!,
        NSAttributedString.Key.kern: 5.0
    ]
}

private extension UIColor {
    static var sampleRed = UIColor(red: 252/255, green: 70/255, blue: 93/255, alpha: 1)
    static var sampleGreen = UIColor(red: 49/255, green: 193/255, blue: 109/255, alpha: 1)
    static var sampleBlue = UIColor(red: 52/255, green: 154/255, blue: 254/255, alpha: 1)
}
