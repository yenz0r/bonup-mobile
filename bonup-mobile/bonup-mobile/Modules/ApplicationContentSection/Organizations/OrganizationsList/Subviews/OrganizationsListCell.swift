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

    var imageLink: URL? {
        didSet {
            
            guard let url = imageLink else {
                
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
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup subviews
    
    private func setupAppearance() {
        
        self.setupSectionStyle()
    }

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
            make.height.equalTo(30.0)
        }
    }

    // MARK: - Configure

    private func configureImageView() -> UIImageView {
        let iv = UIImageView()

        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.layer.cornerRadius = 25
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        return iv
    }

    private func configureTitleLabel() -> UILabel {
        let label = UILabel()

        label.theme_textColor = Colors.defaultTextColor
        label.font = UIFont.avenirRoman(20.0)
        label.textAlignment = .right

        return label
    }
}
