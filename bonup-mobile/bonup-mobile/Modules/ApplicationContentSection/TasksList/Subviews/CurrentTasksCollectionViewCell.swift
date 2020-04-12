//
//  CurrentTasksCollectionViewCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class CurrentTasksCollectionViewCell: UICollectionViewCell {

    // MARK: - Public variables

    static let reuseId = String(describing: type(of: self))

    var titleText: String? {
        didSet {
            self.titleLabel.text = self.titleText
        }
    }

    var descriptionText: String? {
        didSet {
            self.descriptionLabel.text = self.descriptionText
        }
    }

    var aliveTimeText: String? {
        didSet {
            self.aliveTimeLabel.text = self.aliveTimeText
        }
    }

    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }

    // MARK: - Private variables

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var aliveTimeLabel: UILabel!
    private var imageView: UIImageView!
    private var blurView: UIView!
    private var infoContainerView: UIView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.imageView = self.configureImageView()
        self.blurView = self.configureBlurView()
        self.infoContainerView = self.configureInfoContainerView()
        self.titleLabel = self.configureTitleLabel()
        self.descriptionLabel = self.configureDescriptionLabel()
        self.aliveTimeLabel = self.configureAliveTimeLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    private func configureTitleLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirHeavy(20.0)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white80

        self.infoContainerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15.0)
            make.height.greaterThanOrEqualTo(30.0)
        }

        return label
    }

    private func configureDescriptionLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirRoman(15.0)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.white80.withAlphaComponent(0.7)

        self.infoContainerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
            make.bottom.leading.trailing.equalToSuperview().inset(10.0)
        }

        return label
    }

    private func configureImageView() -> UIImageView {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return imageView
    }

    private func configureInfoContainerView() -> UIView {
        let containerView = UIView()

        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.blurView)
        }

        return containerView
    }

    private func configureBlurView() -> UIView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        self.contentView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        return blurEffectView
    }

    private func configureAliveTimeLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirRoman(12.0)
        label.textColor = UIColor.green.withAlphaComponent(0.6)
        label.textAlignment = .right

        self.infoContainerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(10.0)
            make.trailing.equalToSuperview().inset(15.0)
        }

        return label
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.layer.cornerRadius = 10.0
        self.contentView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleText = nil
        self.descriptionText = nil
        self.aliveTimeText = nil
        self.image = nil
    }
}
