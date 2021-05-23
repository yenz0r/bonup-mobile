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

    init(title: String, description: String, imageLink: String, categoryLocTitle: String) {
        super.init(frame: .zero)

        // subviews

        let containerView = self.configureContainerView()
        let infoContainerView = UIView()
        let imageView = self.configureImageView(with: imageLink)
        let titleLabel = self.configureTitleLabel(with: title)
        let descriptionLabel = self.configureDescriptionLabel(with: description)
        let blurView = self.configureBlurView()
        let categoryContainer = self.configureBlurView()
        let categoryLabel = self.configureCategoryLabel(with: categoryLocTitle)

        // setup subviews

        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(categoryContainer)
        categoryContainer.layer.maskedCorners = [.layerMinXMaxYCorner]
        categoryContainer.layer.cornerRadius = 20
        categoryContainer.layer.masksToBounds = true
        categoryContainer.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
        }
        
        containerView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(10)
            make.leading.equalTo(categoryContainer).offset(10)
            make.bottom.equalTo(categoryContainer).offset(-10)
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
            make.leading.trailing.bottom.equalToSuperview().inset(20.0)
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
        containerView.backgroundColor = .white

        return containerView
    }

    private func configureImageView(with imageLink: String) -> BULoadImageView {
        
        let imageView = BULoadImageView(axis: .horizontal)

        if let url = URL(string: imageLink) {
         
            imageView.loadFrom(url: url)
        }

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
    
    private func configureCategoryLabel(with text: String) -> UILabel {
        
        let label = BULabel()
        
        label.textAlignment = .center
        label.font = .avenirHeavy(14)
        label.textColor = .orange.withAlphaComponent(0.8)
        label.loc_text = text
        
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
