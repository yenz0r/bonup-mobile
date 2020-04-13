//
//  CategoryCardView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import Shuffle_iOS

final class CategoryCardView: SwipeCard {

    // MARK: - Override

    override var swipeDirections: [SwipeDirection] {
        return [.left, .right]
    }

    override func overlay(forDirection direction: SwipeDirection) -> UIView? {
        switch direction {
        case .left:
            return TaskCardOverlay.left()
        case.right:
            return TaskCardOverlay.right()
        default:
            return nil
        }
    }

    // MARK: - Initialization

    init(title: String, desctiptionText: String) {
        super.init(frame: .zero)

        // subviews

        let containerView = self.configureContainerView()
        let infoContainerView = UIView()
        let titleLabel = self.configureTitleLabel(with: title)
        let desctiptionLabel = self.configureDescriptionLabel(with: desctiptionText)
        let separatorView = self.configureSeparatorView()
        let blurView = self.configureBlurView()

        // setup subviews

        containerView.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        containerView.addSubview(infoContainerView)
        infoContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(blurView.snp.height)
        }

        infoContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15.0)
        }

        infoContainerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.height.equalTo(1.0)
        }

        infoContainerView.addSubview(desctiptionLabel)
        desctiptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.top.equalTo(separatorView.snp.bottom).offset(10.0)
            make.bottom.equalToSuperview().offset(-15.0)
        }

        self.content = containerView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurations

    private func configureSeparatorView() -> UIView {
        let view = UIView()

        view.backgroundColor = UIColor.white80.withAlphaComponent(0.4)

        return view
    }

    private func configureContainerView() -> UIView {
        let containerView = UIView()

        containerView.layer.cornerRadius = 20.0
        containerView.layer.masksToBounds = true

        return containerView
    }

    private func configureTitleLabel(with text: String) -> UILabel {
        let label = UILabel()

        label.textAlignment = .center
        label.font = UIFont.avenirHeavy(30)
        label.text = text
        label.textColor = .white80

        return label
    }

    private func configureDescriptionLabel(with text: String) -> UILabel {
        let label = UILabel()

        label.textAlignment = .center
        label.font = UIFont.avenirRoman(20.0)
        label.text = text
        label.numberOfLines = 0
        label.textColor = UIColor.white80.withAlphaComponent(0.7)

        return label
    }

    private func configureBlurView() -> UIView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.layer.cornerRadius = 20.0
        blurEffectView.layer.masksToBounds = true

        return blurEffectView
    }
}
