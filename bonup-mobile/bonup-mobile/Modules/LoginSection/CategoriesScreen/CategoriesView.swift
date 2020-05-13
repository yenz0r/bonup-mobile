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
    func relaodData()
}

final class CategoriesView: LoginSectionViewController {

    // MARK: - Public variables

    var presenter: CategoriesPresenter!

    // MARK: - Private variables

    private var titleLabel: UILabel!
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

        self.swipeCardStack = SwipeCardStack()
        self.containerView.addSubview(self.swipeCardStack)
        self.swipeCardStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20.0)
            make.self.bottom.equalToSuperview()
        }

        self.skipButton = UIButton.systemButton(
            for: .onlyText,
            title: "ui_skip_title".localized
        )
        self.view.addSubview(self.skipButton)
        self.skipButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20.0)
            make.height.equalTo(30.0)
            make.width.equalTo(100.0)
            make.centerX.equalToSuperview()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configurations
        self.navigationItem.title = "ui_categories_title".localized
        self.configureViews()

        // data
        self.presenter.handleViewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.presenter.handleViewDidDisappear()
    }

    // MARK: - Configuration

    private func configureViews() {

        // configure title label
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.avenirRoman(20.0)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.white80
        self.titleLabel.text = "ui_categories_text".localized

        // configure card stack view
        self.swipeCardStack.delegate = self
        self.swipeCardStack.dataSource = self

        //configure skip button
        self.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc private func skipButtonTapped() {
        self.presenter.handleSkipButtonTap()
    }
}

// MARK: - ICategoriesView implementation

extension CategoriesView: ICategoriesView {
    func relaodData() {
        self.swipeCardStack.reloadData()
    }
}

// MARK: - SwipeCardStackDelegate implementation

extension CategoriesView: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        self.presenter.handleCardSwipe(at: index, isLike: direction == .right)
    }
}

// MARK: - SwipeCardStackDataSource implementation

extension CategoriesView: SwipeCardStackDataSource {
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return self.presenter.categories.count
    }

    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return CategoryCardView(
            title: self.presenter.categories[index].title,
            desctiptionText: self.presenter.categories[index].description
        )
    }
}
