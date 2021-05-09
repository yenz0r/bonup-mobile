//
//  AddCompanyInputCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class AddCompanyInputCell: UITableViewCell {

    // MARK: - Static

    static let reuseId = NSStringFromClass(AddCompanyInputCell.self)

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupAppearance()
        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public variables

    var onValueChange: ((String?) -> Void)?

    // MARK: - Public functions

    func configure(with model: AddCompanyInputRowModel) {

        self.titleLabel.nonlocalizedTitle = model.rowType.title
        self.textField.text = model.value
        self.isUserInteractionEnabled = model.isEnabled
    }

    // MARK: - UI variabes

    private var titleLabel: BULabel!
    private var textFieldContainer: UIView!
    private var textField: BUTextField!

    // MARK: - Setup

    private func setupAppearance() {

        self.backgroundColor = .clear
    }

    private func setupSubviews() {

        self.titleLabel = self.configureTitleLabel()
        self.textFieldContainer = self.configureTextFieldContainer()
        self.textField = self.configureTextField()

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textFieldContainer)
        self.textFieldContainer.addSubview(self.textField)

        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }

        self.textFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }

        self.textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }

    // MARK: - Configure

    private func configureTitleLabel() -> BULabel {

        let label = BULabel()
        
        label.theme_textColor = Colors.defaultTextColor

        return label
    }

    private func configureTextField() -> BUTextField {

        let textField = BUTextField()

        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        textField.theme_textColor = Colors.defaultTextColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }

    private func configureTextFieldContainer() -> UIView {

        let container = UIView()

        container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true

        return container
    }

    // MARK: - Selectors

    @objc private func textFieldValueChanged(_ sender: UITextField) {

        self.onValueChange?(sender.text)
    }
}
