//
//  AddCompanyInputHeader.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class AddCompanyInputHeader: UIView {
    
    // MARK: - State variables
    
    private var isFirstLayout = true

    // MARK: - Initialization

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.isFirstLayout {
            
            self.isFirstLayout.toggle()
            self.setupBlur()
        }
    }

    // MARK: - Public variables

    var title: String? {

        didSet {

            self.titleLabel.loc_text = self.title
        }
    }

    // MARK: - UI variables

    private var titleLabel: BULabel!

    // MARK: - Setup

    private func setupSubviews() {

        self.titleLabel = self.configureTitleLabel()

        self.addSubview(self.titleLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }

    // MARK: - Configure

    private func configureTitleLabel() -> BULabel {

        let label = BULabel()

        label.font = UIFont.avenirRoman(15)
        label.theme_textColor = Colors.grayTextColor

        return label
    }
}
