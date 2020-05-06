//
//  QRcodeManager.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 06.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class QRcodeManager {

    // MARK: - Static

    static let shared = QRcodeManager()

    // MARK: - Initialization

    private init() { }

    // MARK: - Functions

    func createQRFromString(str: String) -> UIImage? {
        let stringData = str.data(using: .utf8)

        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")

        if let img = filter?.outputImage {
            let someImage = UIImage(
                ciImage: img,
                scale: 1.0,
                orientation: UIImage.Orientation.down
            )
            return someImage
        }

        return nil
    }
}
