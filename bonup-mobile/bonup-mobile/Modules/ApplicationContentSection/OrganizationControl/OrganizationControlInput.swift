//
//  OrganizationControlInput.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class OrganizationControlInput: UIViewController {

    var onClose: ((String, String, Int, Int) -> Void)?

    private var containerView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        return view
    }()

    private var nameTextField: UITextField = {
        let tf = UITextField()

        tf.textAlignment = .center
        tf.placeholder = "ui_name_placeholder".localized
        tf.layer.borderColor = UIColor.purpleLite.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 3
        tf.layer.masksToBounds = true

        return tf
    }()

    private var descriptionTextField: UITextField = {
        let tf = UITextField()

        tf.textAlignment = .center
        tf.placeholder = "ui_description_placeholder".localized
        tf.layer.borderColor = UIColor.purpleLite.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 3
        tf.layer.masksToBounds = true

        return tf
    }()

    private var countTextField: UITextField = {
        let tf = UITextField()

        tf.textAlignment = .center
        tf.placeholder = "ui_count_placeholder".localized
        tf.layer.borderColor = UIColor.purpleLite.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 3
        tf.layer.masksToBounds = true
        tf.keyboardType = .numberPad

        return tf
    }()

    private var typeSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [
            "Premium",
            "Medium",
            "Usual"
        ])
        sc.selectedSegmentIndex = 0
        return sc
    }()

    private var closeButton: UIButton = {
        let btn = UIButton.systemButton(for: .emptyBackgroundButton(contentColor: UIColor.purpleLite), title: "ui_ok".localized)

        btn.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)

        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tg = UITapGestureRecognizer(target: self, action: #selector(handleCloseTap))
        self.view.addGestureRecognizer(tg)

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.nameTextField)
        self.containerView.addSubview(self.descriptionTextField)
        self.containerView.addSubview(self.countTextField)
        self.containerView.addSubview(self.typeSegmentControl)
        self.containerView.addSubview(self.closeButton)

        self.containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(40.0)
        }

        self.nameTextField.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(10.0)
            make.height.equalTo(40.0)
        }

        self.descriptionTextField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(self.nameTextField)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(10.0)
        }

        self.countTextField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(self.nameTextField)
            make.top.equalTo(self.descriptionTextField.snp.bottom).offset(10.0)
        }

        self.typeSegmentControl.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(self.nameTextField)
            make.top.equalTo(self.countTextField.snp.bottom).offset(10.0)
        }

        self.closeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.nameTextField)
            make.top.equalTo(self.typeSegmentControl.snp.bottom).offset(20.0)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(40.0)
        }
    }

    @objc private func handleCloseTap() {

        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func handleCloseButtonTap() {

        guard
            let name = self.nameTextField.text,
            let descriptionText = self.descriptionTextField.text,
            let countText = self.countTextField.text,
            let count = Int(countText)
        else {

            self.closeButton.shake()
            return
        }

        let type = self.typeSegmentControl.selectedSegmentIndex

        self.view.endEditing(true)

        self.dismiss(animated: true) { [weak self] in
            self?.onClose?(
                name,
                descriptionText,
                count,
                type
            )
        }
    }
}
