//
//  TermsAndConditionsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 07.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITermsAndConditionsView: AnyObject { }

final class TermsAndConditionsView: UIViewController {

    // MARK: - Public properties

    var presenter: ITermsAndConditionsPresenter!

    // MARK: - Private properties

    private var textScrollView: UIScrollView!
    private var textScrollContentView: UIView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var contentLabel: UILabel!
    private var doneButton: UIButton!

    // MARK: - Life Cycle

    override func loadView() {
        self.view = UIView()

        self.textScrollView = UIScrollView()
        self.view.addSubview(self.textScrollView)
        self.textScrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.textScrollContentView = UIView()
        self.textScrollView.addSubview(self.textScrollContentView)
        self.textScrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        self.titleLabel = UILabel()
        self.textScrollContentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        self.subtitleLabel = UILabel()
        self.textScrollContentView.addSubview(self.subtitleLabel)
        self.subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }

        self.contentLabel = UILabel()
        self.textScrollContentView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(20)
        }

        self.doneButton = UIButton.systemButton(
            for: .emptyBackgroundButton(contentColor: UIColor.purpleLite),
            title: "ui_done_title".localized
        )
        self.textScrollContentView.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50.0)
            make.top.equalTo(self.contentLabel.snp.bottom).offset(20.0)
            make.height.equalTo(45.0)
            make.bottom.equalToSuperview().offset(-20.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        // Configurations

        self.configureTitleLabel()
        self.configureSubtitleLabel()
        self.configureContentLabel()

        // Setup button action

        self.configureDoneButton()
    }

    // MARK: - Selectors

    @objc private func doneButtonTapped() {
        self.presenter.handleDoneButtonTap()
    }

    // MARK: - Configurations

    private func configureDoneButton() {
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    private func configureTitleLabel() {
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.avenirHeavy(36.0)
        self.titleLabel.text = "ui_bonup_title".localized
    }

    private func configureSubtitleLabel() {
        self.subtitleLabel.textAlignment = .center
        self.subtitleLabel.font = UIFont.avenirHeavy(18.0)
        self.subtitleLabel.text = "ui_terms_conditions_title".localized
    }

    private func configureContentLabel() {
        self.contentLabel.textAlignment = .left
        self.contentLabel.font = UIFont.avenirRoman(14.0)
        self.contentLabel.numberOfLines = 0
        self.contentLabel.text = termAndConditionsText
    }
}

extension TermsAndConditionsView: ITermsAndConditionsView { }
