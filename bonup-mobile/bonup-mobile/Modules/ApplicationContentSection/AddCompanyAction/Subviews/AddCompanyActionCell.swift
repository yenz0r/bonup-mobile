//
//  AddCompanyActionCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import DatePicker

final class AddCompanyActionCell: UITableViewCell {
    
    // MARK: - Static
    
    static let reuseId = NSStringFromClass(AddCompanyActionCell.self)
    
    // MARK: - UI variables
    
    private var titleLabel: BULabel!
    private var valueTextField: UITextField!
    
    // MARK: - Gesture variables
    
    private var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Public variables
    
    var onValueChange: ((Any) -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupSubviews()
        self.setupAppearance()
        self.setupGestures()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    func configure(with title: String, stringValue: String, fieldType: CompanyActionFieldType) {
        
        self.titleLabel.nonlocalizedTitle = title
        self.valueTextField.text = stringValue
        
        switch fieldType {
        case .title:
            fallthrough
        case .description:
            fallthrough
        case .allowedCount:
            fallthrough
        case .bonuses:
            self.valueTextField.isEnabled = true
            self.valueTextField.keyboardType = fieldType == .bonuses || fieldType == .allowedCount ? .numberPad : .alphabet;
            self.tapGesture.isEnabled = false
            
        case .startDate:
            fallthrough
        case .endDate:
            self.valueTextField.isEnabled = false
            self.tapGesture.isEnabled = true
        }
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        
        self.titleLabel = self.configureTitleLabel()
        self.valueTextField = self.configureTextField()
        let textFieldContainer = self.configureTextFieldContainer()
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(textFieldContainer)
        textFieldContainer.addSubview(self.valueTextField)
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(10)
        }
        
        textFieldContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    
        self.valueTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    private func setupAppearance() {
        
        self.contentView.theme_backgroundColor = Colors.backgroundColor
    }
    
    private func setupGestures() {
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureTapped(_:)))
        self.contentView.addGestureRecognizer(self.tapGesture)
    }
    
    // MARK: - Configure
    
    private func configureTextFieldContainer() -> UIView {
        
        let container = UIView()
        
        container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.14)
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        
        return container
    }
    
    private func configureTextField() -> BUTextField {
        
        let tf = BUTextField()
        
        tf.delegate = self
        tf.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        tf.theme_textColor = Colors.defaultTextColor
        
        return tf
    }
    
    private func configureTitleLabel() -> BULabel {
        
        let label = BULabel()
        
        label.theme_textColor = Colors.defaultTextColor
        label.textAlignment = .left
        label.font = .avenirHeavy(15.0)
        
        return label
    }
    
    // MARK: - Selectors
    
    @objc private func textFieldChanged(_ sender: UITextField) {
     
        self.onValueChange?((sender.text ?? "") as Any)
    }
    
    @objc private func gestureTapped(_ sender: UITapGestureRecognizer) {
        
        self.contentView.endEditing(true)
        
        let datePicker = DatePicker()
        datePicker.setup(beginWith: Date()) { [weak self] selected, date in
            
            if selected {
                
                let newDate = date ?? Date()
                
                self?.onValueChange?(newDate)
                self?.valueTextField.text = Date.dateFormatter.string(from: newDate)
            }
        }
        
        // NOTE: - Replace this logic in roter
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let controller = appDelegate.window?.rootViewController else { return }
        
        datePicker.show(in: controller)
    }
}

// MARK: - UITextFieldDelegate

extension AddCompanyActionCell: UITextFieldDelegate { }
