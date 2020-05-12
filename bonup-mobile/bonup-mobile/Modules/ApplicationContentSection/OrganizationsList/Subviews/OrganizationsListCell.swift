//
//  OrganizationsListCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

// -- Helpers --

import Nuke

final class OrganizationsListCell: UICollectionViewCell {

    // MARK: - Static variables

    static let reuseId = String(describing: type(of: self))

    // MARK: - Public variables

    var imageLink: String? {
        didSet {
            guard let link = imageLink, let url = URL(string: link) else {
                self.imageView.image = nil
                return
            }

            let imageRequst = ImageRequest(url: url)
            Nuke.loadImage(
                with: imageRequst,
                options: ImageLoadingOptions(),
                into: self.imageView,
                progress: nil,
                completion: nil
            )
        }
    }

    var titleText: String? {
        didSet {
            self.titleLabel.text = self.titleText
        }
    }

    // MARK: - User interface variables

    private var imageView: UIImageView!
    private var titleLabel: UILabel!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup subviews

    private func setupSubviews() {

        self.imageView = self.configureImageView()
        self.titleLabel = self.configureTitleLabel()

        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)

        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.titleLabel.snp.top).offset(-8.0)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(8.0)
        }
    }

    // MARK: - Configure

    private func configureImageView() -> UIImageView {
        let iv = UIImageView()

        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        return iv
    }

    private func configureTitleLabel() -> UILabel {
        let label = UILabel()

        label.textColor = UIColor.purpleLite.withAlphaComponent(0.6)
        label.font = UIFont.avenirRoman(20.0)
        label.textAlignment = .right

        return label
    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.borderColor = UIColor.purpleLite.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
        self.backgroundColor = .white
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleText = nil
        self.imageLink = nil
    }
}
