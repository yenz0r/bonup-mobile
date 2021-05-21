//
//  BUSearchBar.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class BUSearchBar: UIView {
    
    // MARK: - Public properties
    
    var value: String? {
        
        didSet {
            
            self.searchTextField.text = value
        }
    }
    var onSearchChange: ((String?) -> Void)?
    var placeholderLocalizationKey: String? {
        
        didSet {
            
            self.searchTextField.placeholderLocalicationKey = placeholderLocalizationKey
        }
    }
    
    // MARK: - Private variables
    
    private var editingsCount = 0
    
    // MARK: - UI variables
    
    private var searchTextField: BUTextField!
    
    // MARK: - Init
    
    init() {
        
        super.init(frame: .zero)
        
        self.setupAppearance()
        self.setupSubivews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    func stopEditing() {
        
        self.searchTextField.resignFirstResponder()
    }
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        
        self.setupBlur()
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.backgroundColor = .darkGray.withAlphaComponent(0.2)
        
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        self.layer.theme_borderColor = Colors.borderCGColor
        self.layer.borderWidth = 1
    }
    
    private func setupSubivews() {
        
        self.searchTextField = self.configureTextField()
        self.addSubview(self.searchTextField)
        self.searchTextField.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        self.snp.makeConstraints { $0.height.equalTo(50) }
    }
    
    // MARK: - Configure
    
    private func configureTextField() -> BUTextField {
        
        let tf = BUTextField()
        
        tf.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        tf.delegate = self
        tf.theme_textColor = Colors.defaultTextColor
        
        return tf
    }
    
    // MARK: - Selectors
    
    @objc private func textChanged(_ sender: BUTextField) {
     
        self.editingsCount += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.editingsCount -= 1
            
            if self.editingsCount == 0 {
                
                self.onSearchChange?(sender.text)
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension BUSearchBar: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.stopEditing()
        
        return true
    }
}
