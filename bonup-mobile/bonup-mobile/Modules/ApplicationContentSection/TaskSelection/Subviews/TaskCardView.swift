//
//  TaskCardView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Shuffle_iOS
import UIKit

final class TaskCardView: SwipeCard {

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

    init(title: String, description: String, image: UIImage?) {
        super.init(frame: .zero)

        // subviews

        let containerView = self.configureContainerView()
        let infoContainerView = UIView()
        let imageView = self.configureImageView(with: image)
        let titleLabel = self.configureTitleLabel(with: title)
        let descriptionLabel = self.configureDescriptionLabel(with: description)
        let blurView = self.configureBlurView()

        // setup subviews

        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
            make.height.greaterThanOrEqualTo(20.0)
        }

        infoContainerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.height.greaterThanOrEqualTo(40.0)
        }

        self.content = containerView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurations

    private func configureContainerView() -> UIView {
        let containerView = UIView()

        containerView.layer.cornerRadius = 20.0
        containerView.layer.masksToBounds = true

        return containerView
    }

    private func configureImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView()

        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }

    private func configureTitleLabel(with text: String) -> UILabel {
        let label = UILabel()

        label.textAlignment = .left
        label.font = UIFont.avenirHeavy(25)
        label.text = text
        label.textColor = .white80

        return label
    }

    private func configureDescriptionLabel(with text: String) -> UILabel {
        let label = UILabel()

        label.textAlignment = .left
        label.font = UIFont.avenirRoman(20)
        label.text = text
        label.textColor = UIColor.white80.withAlphaComponent(0.4)
        label.numberOfLines = 0

        return label
    }

    private func configureBlurView() -> UIView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        return blurEffectView
    }
}
