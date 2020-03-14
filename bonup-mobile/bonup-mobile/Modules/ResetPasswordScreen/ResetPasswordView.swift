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
}

final class ResetPasswordView: UIViewController {

    // MARK: - Public properties

    var presenter: IResetPasswordPresenter!

    // MARK: - Private properties

    private var infoLabel: UILabel!
    private var emailTextField: UITextField!
    private var sendButton: UIButton!

    private var containerView: UIView!

    // MARK: - Lyfe cycle

    override func loadView() {
        self.view = UIView()

        self.containerView = UIView()
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40.0)
        }

        self.infoLabel = UILabel()
        self.containerView.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        self.emailTextField = UITextField()
        self.containerView.addSubview(self.emailTextField)
        self.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(self.infoLabel.snp.bottom).offset(30.0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45.0)
        }

        self.sendButton = UIButton.systemButton(for: .yellowButton, title: "ui_send_mail_title".localized)
        self.containerView.addSubview(self.sendButton)
        self.sendButton.snp.makeConstraints { make in
            make.top.equalTo(self.emailTextField.snp.bottom).offset(10.0)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(45.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        self.presenter.viewDidLoad()

        // configurations

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
        self.emailTextField.textAlignment = .center
        self.emailTextField.layer.cornerRadius = 20.0
        self.emailTextField.layer.masksToBounds = true
        self.emailTextField.attributedPlaceholder = NSAttributedString.with(
            title: "ui_email_placeholder".localized,
            textColor: UIColor.black.withAlphaComponent(0.3),
            font: UIFont.avenirRoman(14)
        )
        self.emailTextField.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
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
}
