//
//  CategoriesView.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import Shuffle_iOS

protocol ICategoriesView: AnyObject {

}

final class CategoriesView: LoginSectionViewController {

    // MARK: - Public variables

    var presenter: CategoriesPresenter!

    // MARK: - Private variables

    private var titleLabel: UILabel!
    private var locationTextField: UITextField!
    private var swipeCardStack: SwipeCardStack!
    private var skipButton: UIButton!
    private var containerView: UIView!

    // MARK: - Life cycle

    override func loadView() {
        super.loadView()

        self.view.subviews.forEach { $0.removeFromSuperview() }

        self.containerView = UIView()
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40.0)
        }

        self.titleLabel = UILabel()
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }

        self.locationTextField = UITextField.loginTextField(with: "ui_location_placeholder".localized)
        self.containerView.addSubview(self.locationTextField)
        self.locationTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20.0)
            make.height.equalTo(45.0)
        }

        self.swipeCardStack = SwipeCardStack()
        self.containerView.addSubview(self.swipeCardStack)
        self.swipeCardStack.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.locationTextField.snp.bottom).offset(20.0)
        }

        self.skipButton = UIButton.systemButton(
            for: .onlyText,
            title: "ui_skip_title".localized
        )
        self.view.addSubview(self.skipButton)
        self.skipButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20.0)
            make.height.equalTo(30)
            make.width.equalTo(50.0)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // configurations
        self.navigationItem.title = "ui_categories_title".localized
        self.configureViews()
        
    }

    // MARK: - Configuration

    private func configureViews() {
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.avenirRoman(20.0)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.white80
        self.titleLabel.text = "ui_categories_text".localized
    }
}

// MARK: - ICategoriesView implementation

extension CategoriesView: ICategoriesView {

}
