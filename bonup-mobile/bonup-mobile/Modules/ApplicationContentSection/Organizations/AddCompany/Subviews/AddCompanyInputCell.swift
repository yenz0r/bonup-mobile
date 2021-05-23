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
        self.setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public variables

    var onValueChange: ((String?) -> Void)?
    var onTap: (() -> Void)?

    // MARK: - Public functions

    func configure(with model: AddCompanyInputRowModel) {

        self.titleLabel.loc_text = model.rowType.title
        
        self.textField.text = model.value
        self.setupTextFieldAppearance(isEnabled: model.isEnabled && model.rowType != .address)
        self.tapGesture.isEnabled = model.rowType == .address
        
        self.isUserInteractionEnabled = model.isEnabled
    }

    // MARK: - UI variabes

    private var titleLabel: BULabel!
    private var textFieldContainer: UIView!
    private var textField: BUTextField!
    
    // MARK: - Private variables
    
    private var tapGesture: UITapGestureRecognizer!

    // MARK: - Setup
    
    private func setupGestures() {
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTriggered))
        self.contentView.addGestureRecognizer(self.tapGesture)
    }

    private func setupAppearance() {

        self.backgroundColor = .clear
    }

    private func setupTextFieldAppearance(isEnabled: Bool) {
        
        self.textField.isEnabled = isEnabled
        self.textField.alpha = isEnabled ? 1.0 : 0.5
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
    
    @objc private func tapGestureTriggered() {
        
        self.textField.resignFirstResponder()
        self.onTap?()
    }
}
