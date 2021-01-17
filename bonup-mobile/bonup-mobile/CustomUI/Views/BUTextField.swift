//
//  BUTextField.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class BUTextField: UITextField {

    // MARK: - Initialization

    init() {

        super.init(frame: .zero)

        self.setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupAppearance() {

        self.theme_keyboardAppearance = Colors.keyboardAppearance
    }
}
