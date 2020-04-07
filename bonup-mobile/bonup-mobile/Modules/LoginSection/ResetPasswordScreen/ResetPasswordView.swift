//
//  ResetPasswordView.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IResetPasswordView: AnyObject {
    func setupEmailText(_ email: String?)
    func shakeSendButtonAnimation()
}

final class ResetPasswordView: LoginSectionViewController {

    // MARK: - Public properties

    var presenter: IResetPasswordPresenter!

    // MARK: - Private properties

    private var infoLabel: UILabel!
    private var emailTextField: UITextField!
    private var sendButton: UIButton!
    private var logoImageView: UIImageView!
    private var containerView: UIView!

    // MARK: - Life cycle

    override func loadView() {
        super.loadView()

        self.containerView = UIView()
        self.scrollContentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40.0)
        }
        self.bottomControlView = self.containerView

        self.logoImageView = UIImageView()
        self.containerView.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(90.0)
            make.height.equalTo(self.logoImageView.snp.width)
        }

        self.infoLabel = UILabel()
        self.containerView.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.logoImageView.snp.bottom).offset(20.0)
            make.leading.trailing.equalToSuperview()
        }

        self.emailTextField = UITextField.loginTextField(with: "ui_email_placeholder".localized)
        self.containerView.addSubview(self.emailTextField)
        self.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(self.infoLabel.snp.bottom).offset(30.0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45.0)
        }

        self.sendButton = UIButton.systemButton(for: .emptyBackgroundButton(contentColor: .white), title: "ui_send_mail_title".localized)
        self.containerView.addSubview(self.sendButton)
        self.sendButton.snp.makeConstraints { make in
            make.top.equalTo(self.emailTextField.snp.bottom).offset(10.0)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(45.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.viewDidLoad()

        // configurations

        self.logoImageView.image = AssetsHelper.shared.image(.emailLogo)

        self.navigationItem.title = "ui_reset_password_title".localized

        self.configureInfoLabel()
        self.configureEmailTextField()

        self.sendButton.addTarget(self, action: #selector(self.sendButtonTapped), for: .touchUpInside)
    }

    // MARK: - Configuration

    private func configureInfoLabel() {
        self.infoLabel.numberOfLines = 0
        self.infoLabel.font = UIFont.avenirRoman(20.0)
        self.infoLabel.textAlignment = .center
        self.infoLabel.textColor = .white
        self.infoLabel.text = "reset_password_info".localized
    }

    private func configureEmailTextField() {
        self.emailTextField.delegate = self
        self.emailTextField.keyboardType = .emailAddress
    }

    // MARK: - Selectors

    @objc private func sendButtonTapped() {
        self.presenter.handleSendButtonTapped(self.emailTextField.text)
    }
}

// MARK: - IResetPasswordView implementation

extension ResetPasswordView: IResetPasswordView {
    func setupEmailText(_ email: String?) {
        self.emailTextField.text = email
    }

    func shakeSendButtonAnimation() {
        self.sendButton.shake()
    }
}
