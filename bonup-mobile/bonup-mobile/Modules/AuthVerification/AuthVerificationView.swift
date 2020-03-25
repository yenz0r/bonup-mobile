//
//  AuthVerificationView.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IAuthVerificationView: AnyObject {
    func displayTimerText(_ text: String)
}

final class AuthVerificationView: LoginSectionViewController {

    // MARK: - Public variables

    var presenter: AuthVerificationPresenter!

    // MARK: - Private variables

    private var containerView: UIView!
    private var titleLabel: UILabel!
    private var codeTextField: UITextField!
    private var sendButton: UIButton!
    private var timerLabel: UILabel!
    private var resendButton: UIButton!

    // MARK: - Life cycle

    override func loadView() {
        super.loadView()

        self.containerView = UIView()
        self.scrollContentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(38.0)
            make.center.equalToSuperview()
        }
        self.bottomControlView = self.containerView

        self.titleLabel = UILabel()
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }

        self.codeTextField = UITextField.loginTextField(with: "ui_code_placeholder".localized)
        self.containerView.addSubview(self.codeTextField)
        self.codeTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45.0)
        }

        self.sendButton = UIButton.systemButton(for: .emptyBackgroundButton, title: "ui_send_code_title".localized)
        self.containerView.addSubview(self.sendButton)
        self.sendButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45.0)
            make.top.equalTo(self.codeTextField.snp.bottom).offset(10)
        }

        self.timerLabel = UILabel()
        self.containerView.addSubview(self.timerLabel)
        self.timerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(self.sendButton.snp.bottom).offset(10.0)
            make.height.equalTo(15.0)
        }

        self.resendButton = UIButton(type: .system)
        self.containerView.addSubview(self.resendButton)
        self.resendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20.0)
            make.top.equalTo(self.sendButton.snp.bottom).offset(10)
            make.height.equalTo(15.0)
            make.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.presenter.viewDidAppear()
    }

    // MARK: - Private functions

    private func configureViews() {
        self.navigationItem.title = "ui_auth_verification_title".localized

        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.avenirRoman(20.0)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.white80
        self.titleLabel.text = "ui_code_verification_title".localized

        self.resendButton.setAttributedTitle(
            NSAttributedString.with(
                title: "ui_send_again_title".localized,
                textColor: UIColor.white80,
                font: UIFont.avenirRoman(12)
            ),
            for: .normal
        )
        self.resendButton.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)

        self.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc private func resendButtonTapped() {
        self.presenter.handleResendButtonTap()
    }

    @objc private func sendButtonTapped() {
        self.presenter.handleSendButtonTap(code: self.codeTextField.text)
    }

}

// MARK: - IAuthVerificationView implementation

extension AuthVerificationView: IAuthVerificationView {
    func displayTimerText(_ text: String) {
        self.timerLabel.text = text
    }
}
