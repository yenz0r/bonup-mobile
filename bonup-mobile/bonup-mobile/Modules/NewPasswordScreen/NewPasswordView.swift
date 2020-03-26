//
//  NewPasswordView.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol INewPasswordView: AnyObject {

}

final class NewPasswordView: LoginSectionViewController {

    enum PasswordTextFieldType {
        case newPass, repeatPass
    }

    // MARK: - Public variables

    var presenter: NewPasswordPresenter!

    // MARK: - Private variables

    private var newPasswordTextField: UITextField!
    private var repeatPasswordTextField: UITextField!
    private var sendButton: UIButton!

    private var containerStackView: UIStackView!
    private var infoLabel: UILabel!

    // MARK: - Life cycle

    override func loadView() {
        super.loadView()

        self.containerStackView = self.configureStackView()
        self.scrollContentView.addSubview(self.containerStackView)
        self.containerStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40.0)
            make.height.equalTo(155.0)
        }
        self.bottomControlView = self.containerStackView

        self.newPasswordTextField = self.configureTextField(for: .newPass)
        self.repeatPasswordTextField = self.configureTextField(for: .repeatPass)
        self.sendButton = UIButton.systemButton(for: .emptyBackgroundButton, title: "ui_save_title".localized)

        self.containerStackView.addArrangedSubview(self.newPasswordTextField)
        self.containerStackView.addArrangedSubview(self.repeatPasswordTextField)
        self.containerStackView.addArrangedSubview(self.sendButton)

        self.infoLabel = UILabel()
        self.scrollContentView.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.containerStackView.snp.top).offset(-20.0)
            make.leading.trailing.equalTo(self.containerStackView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "ui_new_password_title".localized

        self.infoLabel.numberOfLines = 0
        self.infoLabel.textAlignment = .center
        self.infoLabel.text = "ui_new_password_info".localized

        self.sendButton.addTarget(self, action: #selector(self.sendButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc private func sendButtonTapped() {
        guard
            let newText = self.newPasswordTextField.text,
            let repeatText = self.repeatPasswordTextField.text,

            newText != "",
            repeatText == newText else {
                self.sendButton.shake()
                return
        }

        self.presenter.handleSendButtonTapped(
            newPass: newText,
            repeatPass: repeatText
        )
    }

    // MARK: - Configuration

    private func configureStackView() -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0

        return stackView
    }

    private func configureTextField(for type: PasswordTextFieldType) -> UITextField {
        let tf = UITextField()

        tf.layer.cornerRadius = 20.0
        tf.layer.masksToBounds = true
        tf.textAlignment = .center
        tf.backgroundColor = UIColor.pinkishGrey.withAlphaComponent(0.3)
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1

        tf.delegate = self
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no

        switch type {
        case .newPass:
            tf.attributedPlaceholder = NSAttributedString.with(
                title: "ui_new_password_placeholder".localized,
                textColor: UIColor.white.withAlphaComponent(0.8),
                font: UIFont.avenirRoman(14.0)
            )
        case .repeatPass:
            tf.attributedPlaceholder = NSAttributedString.with(
                title: "ui_repeat_password_placeholder".localized,
                textColor: UIColor.white.withAlphaComponent(0.8),
                font: UIFont.avenirRoman(14.0)
            )
        }

        return tf
    }
}

// MARK: - INewPasswordView implementation

extension NewPasswordView: INewPasswordView {

}

