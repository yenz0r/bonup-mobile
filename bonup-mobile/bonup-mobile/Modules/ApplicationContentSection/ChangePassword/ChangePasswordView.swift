//
//  ChangePasswordView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IChangePasswordView: AnyObject { }

final class ChangePasswordView: LoginSectionViewController {

    // MARK: - Public variables

    var presenter: IChangePasswordPresenter!

    // MARK: - Private variables

    private var containerStackView: UIStackView!
    private var oldPassword: UITextField!
    private var newPassword: UITextField!
    private var repeatPassword: UITextField!
    private var changeButton: UIButton!

    // MARK: - Lify Cicle

    override func loadView() {
        super.loadView()

        self.containerStackView = UIStackView()
        self.scrollContentView.addSubview(self.containerStackView)
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(210.0)
        }

        self.oldPassword = UITextField.loginTextField(with: "ui_old_password_title".localized)
        self.newPassword = UITextField.loginTextField(with: "ui_new_password_title".localized)
        self.repeatPassword = UITextField.loginTextField(with: "ui_repeat_password_placeholder".localized)
        self.changeButton = UIButton.systemButton(for: .whiteButton, title: "ui_change_title".localized)

        [self.oldPassword,
         self.newPassword,
         self.repeatPassword,
         self.changeButton].forEach { self.containerStackView.addArrangedSubview($0) }

        self.bottomControlView = self.containerStackView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // configurations
        self.navigationItem.title = "ui_change_password_title".localized
        self.configureStackView()
        self.configureTextFields()
        self.changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    }

    // MARK: - Configurations

    private func configureStackView() {
        self.containerStackView.axis = .vertical
        self.containerStackView.distribution = .fillEqually
        self.containerStackView.spacing = 10.0
    }

    private func configureTextFields() {
        [self.oldPassword,
         self.newPassword,
         self.repeatPassword].forEach {
            $0?.isSecureTextEntry = true
        }
    }

    // MARK: - Selectors

    @objc private func changeButtonTapped() {
        self.presenter.handleChangeButtonTap(
            oldPass: self.oldPassword.text,
            newPass: self.newPassword.text,
            repeatPass: self.repeatPassword.text
        )
    }
}

// MARK: - IChangePasswordView

extension ChangePasswordView: IChangePasswordView { }
