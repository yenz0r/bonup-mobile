//
//  BUQRCodeView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 23.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class BUQRCodeView: UIView {
    
    // MARK: - Public variales
    
    var code: String = "" {
        
        didSet {
            
            self.setupQRcode()
        }
    }
    
    // MARK: - Init
    
    init() {
        
        super.init(frame: .zero)
        
        self.setupSubviews()
        self.setupAppearance()
        self.setupObserver()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI variales
    
    private var imageView: UIImageView!
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.setupSectionStyle()
    }
    
    private func setupObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.themeChanged),
                                               name: ThemeColorsManager.shared.notificationName,
                                               object: nil)
    }
    
    private func setupSubviews() {
        
        self.imageView = self.configureImageView()
        
        self.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func setupQRcode() {
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setDefaults()
        let qrData = self.code.data(using: String.Encoding.isoLatin1)
        qrFilter?.setValue(qrData, forKey: "inputMessage")
        let qrCodeCIImage = qrFilter?.outputImage?.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        
        let transparentBG = CIColor.clear
        let qrColor = Colors.textStateCiColor
        
        colorFilter?.setValue(qrCodeCIImage, forKey: "inputImage")
        colorFilter?.setValue(qrColor, forKey: "inputColor0")
        colorFilter?.setValue(transparentBG, forKey: "inputColor1")
        
        let uiImage: UIImage
        
        if let ciImage = colorFilter?.outputImage {
            
            uiImage = UIImage(ciImage: ciImage)
        }
        else {
            
            uiImage = AssetsHelper.shared.image(.emptyTasksListIcon)!
        }
        
        self.imageView.image = uiImage
    }
    
    // MARK: - Configure
    
    private func configureImageView() -> UIImageView {
        
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        
        return iv
    }
    
    // MARK: - Selectors
    
    @objc private func themeChanged() {
        
        self.setupQRcode()
    }
}
