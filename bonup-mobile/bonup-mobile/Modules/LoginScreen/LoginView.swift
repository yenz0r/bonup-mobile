//
//  LoginView.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import SnapKit

protocol ILoginView: AnyObject { }

final class LoginView: LoginSectionViewController {

    enum LoginFieldType {
        case name, email, password
    }

    enum SingButtonType {
        case signIn, signUp
    }

    // MARK: - Public variables

    var presenter: ILoginPresenter!

    // MARK: - Private variables

    private var logoImageView: UIImageView!
    private var mainContainerView: UIView!
    private var containerView: UIView!
    private var inputStackView: UIStackView!
    private var nameTextField: UITextField!
    private var passwordTextField: UITextField!
    private var emailTextField: UITextField!
    private var forgotPasswordButton: UIButton!
    private var signUpButton: UIButton!
    private var signInButton: UIButton!
    private var signButtonsStackView: UIStackView!
    private var termsConditionsButton: UIButton!

    // MARK: - Life Cicle

    override func loadView() {
        super.loadView()

        self.mainContainerView = UIView()
        self.scrollContentView.addSubview(self.mainContainerView)
        self.mainContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.containerView = UIView()
        self.scrollContentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40.0)
        }
        self.bottomControlView = self.containerView

        self.logoImageView = UIImageView()
        self.containerView.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(containerView)
            make.width.equalTo(self.logoImageView.snp.height)
        }

        self.inputStackView = UIStackView()
        self.containerView.addSubview(self.inputStackView)
        self.inputStackView.snp.makeConstraints { make in
            make.top.equalTo(self.logoImageView.snp.bottom).offset(10.0)
            make.leading.trailing.equalTo(self.logoImageView)
            make.height.equalTo(150.0)
        }

        self.forgotPasswordButton = UIButton(type: .system)
        self.containerView.addSubview(self.forgotPasswordButton)
        self.forgotPasswordButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(self.inputStackView.snp.bottom).offset(5.0)
            make.width.equalTo(100.0)
            make.height.equalTo(20.0)
        }

        self.signButtonsStackView = UIStackView()
        self.containerView.addSubview(self.signButtonsStackView)
        self.signButtonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.forgotPasswordButton.snp.bottom).offset(30.0)
            make.height.equalTo(45.0)
            make.bottom.equalToSuperview()
        }

        self.termsConditionsButton = UIButton(type: .system)
        self.view.addSubview(self.termsConditionsButton)
        self.termsConditionsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10.0)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(20)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup logo

        self.logoImageView.image = AssetsHelper.shared.image(.bonupLogo)

        // setup container

        self.mainContainerView.backgroundColor = .clear

        // setup inputStackView

        self.inputStackView.axis = .vertical
        self.inputStackView.distribution = .fillEqually
        self.inputStackView.spacing = 10.0

        self.inputStackView.addArrangedSubview(self.configureInputField(for: .name))
        self.inputStackView.addArrangedSubview(self.configureInputField(for: .email))
        self.inputStackView.addArrangedSubview(self.configureInputField(for: .password))

        // setup forgotPasswordButton

        self.forgotPasswordButton.backgroundColor = .clear
        self.forgotPasswordButton.setAttributedTitle(
            NSAttributedString.with(
                title: "ui_forgot_password_title".localized,
                textColor: UIColor.pinkishGrey.withAlphaComponent(0.6),
                font: UIFont.avenirRoman(12)
            ),
            for: .normal
        )
        self.forgotPasswordButton.addTarget(self, action: #selector(self.forgotPasswordButtonTapped), for: .touchUpInside)

        // setup signButtons

        self.signButtonsStackView.axis = .horizontal
        self.signButtonsStackView.distribution = .fillEqually
        self.signButtonsStackView.spacing = 10.0

        self.signInButton = UIButton.systemButton(for: .whiteButton, title: "ui_sign_in_title".localized)
        self.signInButton.addTarget(self, action: #selector(self.signInButtonTapped), for: .touchUpInside)

        self.signUpButton = UIButton.systemButton(for: .emptyBackgroundButton, title: "ui_sign_up_title".localized)
        self.signUpButton.addTarget(self, action: #selector(self.signUpButtonTapped), for: .touchUpInside)

        self.signButtonsStackView.addArrangedSubview(self.signInButton)
        self.signButtonsStackView.addArrangedSubview(self.signUpButton)

        // setup termsAndConditions

        self.termsConditionsButton.backgroundColor = .clear
        self.termsConditionsButton.setAttributedTitle(
            NSAttributedString.with(
                title: "ui_terms_conditions_title".localized,
                textColor: UIColor.pinkishGrey.withAlphaComponent(0.6),
                font: UIFont.avenirRoman(12)
            ),
            for: .normal)
        self.termsConditionsButton.addTarget(self, action: #selector(self.termConditionsButtonTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Configuration

    private func configureContainerView() -> UIView {
        let container = UIView()

        container.layer.cornerRadius = 15.0
        container.layer.borderColor = UIColor.white.cgColor
        container.layer.borderWidth = 1.0
        container.clipsToBounds = true
        container.backgroundColor = UIColor.pinkishGrey.withAlphaComponent(0.3)

        return container
    }

    private func configureTextField(with placeholder: String) -> UITextField {
        let textField = UITextField()

        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.8),
                .font: UIFont.avenirRoman(14)
            ]
        )
        textField.textAlignment = .center

        return textField
    }

    private func configureInputField(for type: LoginFieldType) -> UIView {
        let containerView = self.configureContainerView()

        let iconImageView = UIImageView()
        containerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(25.0)
            make.leading.equalToSuperview().offset(8.0)
        }

        var textField: UITextField

        switch type {
        case .name:
            iconImageView.image = AssetsHelper.shared.image(.usernameIcon)
            self.nameTextField = self.configureTextField(with: "ui_name_placeholder".localized)
            textField = self.nameTextField
        case .password:
            iconImageView.image = AssetsHelper.shared.image(.passwordIcon)
            self.passwordTextField = self.configureTextField(with: "ui_password_placeholder".localized)
            self.passwordTextField.isSecureTextEntry = true
            textField = self.passwordTextField

            let eyeButton = UIButton(type: .system)
            eyeButton.setImage(AssetsHelper.shared.image(.eyeIcon), for: .normal)
            eyeButton.tintColor = UIColor.white80

            eyeButton.addTarget(self, action: #selector(eyeTouchedDown), for: .touchDown)
            eyeButton.addTarget(self, action: #selector(eyeTouchedUp), for: .touchUpInside)

            containerView.addSubview(eyeButton)
            eyeButton.snp.makeConstraints { make in
                make.size.equalTo(25.0)
                make.trailing.equalToSuperview().inset(10.0)
                make.centerY.equalToSuperview()
            }
        case .email:
            iconImageView.image = AssetsHelper.shared.image(.emailIcon)
            self.emailTextField = self.configureTextField(with: "ui_email_placeholder".localized)
            textField = self.emailTextField
            textField.keyboardType = .emailAddress
        }

        textField.autocorrectionType = .no
        textField.delegate = self

        containerView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10.0)
            make.height.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30.0)
        }

        return containerView
    }

    // MARK: - Selectors

    @objc private func forgotPasswordButtonTapped() {
        self.presenter.handleResetPasswordButtonTap(with: self.emailTextField.text)
    }

    @objc private func termConditionsButtonTapped() {
        self.presenter.handleTermAndConditionButtonTap()
    }

    @objc private func signUpButtonTapped() {
        self.presenter.handleSignButtonTap(
            name: self.nameTextField.text,
            email: self.emailTextField.text,
            password: self.passwordTextField.text,
            type: .register
        )
    }

    @objc private func signInButtonTapped() {
        self.presenter.handleSignButtonTap(
            name: self.nameTextField.text,
            email: self.emailTextField.text,
            password: self.passwordTextField.text,
            type: .auth
        )
    }

    @objc private func eyeTouchedDown() {
        self.passwordTextField.isSecureTextEntry = false
    }

    @objc private func eyeTouchedUp() {
        self.passwordTextField.isSecureTextEntry = true
    }
}

// MARK: - ILoginView implementation

extension LoginView: ILoginView { }
