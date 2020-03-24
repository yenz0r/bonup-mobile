//
//  LoginSectionViewController.swift
//  bonup-mobile
//
//  Created by yenz0redd on 24.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

class LoginSectionViewController: UIViewController {

    // MARK: - Private variables

    private var scrollView: UIScrollView!

    // MARK: - Public variables

    var scrollContentView: UIView!
    var bottomControlView: UIView!

    // MARK: - Life cycle

    override func loadView() {
        self.view = UIView()

        self.scrollView = UIScrollView()
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        self.scrollContentView = UIView()
        self.scrollView.addSubview(self.scrollContentView)
        self.scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideViewTapped))
        self.view.addGestureRecognizer(tapGesture)

        self.scrollView.isScrollEnabled = false

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.setupGradient(UIColor.loginGradientColors)
    }

    // MARK: - Selectors

    @objc private func hideViewTapped() {
        self.view.endEditing(true)
    }

    @objc private func keyboardWillShown(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        let offset = keyboardFrame.origin.y - self.bottomControlView.frame.maxY - 10.0

        self.scrollView.contentOffset = CGPoint(x: 0, y: -offset)
    }

    @objc private func keyboardWillHiden() {
        self.scrollView.contentOffset = .zero
    }
}

// MARK: - UITextFieldDelegate

extension LoginSectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }
}
