//
//  BULoadImageView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 23.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import CircleProgressView
import Nuke

final class BULoadImageView: UIImageView {
 
    enum ConstraintsAxis {
        
        case vertical, horizontal
    }
    
    // MARK: - UI variables
    
    private var progressBar: CircleProgressView!
    
    // MARK: - Public variables
    
    var loadingProgress: Double = 0 {
        
        didSet {
            
            DispatchQueue.main.async {
             
                self.progressBar.progress = self.loadingProgress
            }
        }
    }
    
    // MARK: - Public functions
    
    func showLoader() {
        
        DispatchQueue.main.async {
            
            self.progressBar.progress = 0
            self.progressBar.isHidden = false
        }
    }
    
    func hideLoader() {
        
        DispatchQueue.main.async {
            
            self.progressBar.isHidden = true
        }
    }
    
    func loadFrom(url: URL) {
        
        let options = ImageLoadingOptions()
        
        let imageRequst = ImageRequest(url: url)
        Nuke.loadImage(
            with: imageRequst,
            options: options,
            into: self,
            progress: { [weak self] response, first, second in
                
                self?.showLoader()
                self?.loadingProgress = Double(first) / Double(second)
            },
            completion: { [weak self] _ in
                
                self?.hideLoader()
            }
        )
    }
    
    // MARK: - Init
    
    init(axis: ConstraintsAxis = .vertical) {
        
        super.init(frame: .zero)
        
        self.setupSubviews(axis: axis)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupSubviews(axis: ConstraintsAxis) {
        
        self.progressBar = CircleProgressView()
        self.progressBar.isHidden = true
        self.progressBar.backgroundColor = .clear
        self.progressBar.trackBackgroundColor = .clear
        self.progressBar.contentView.backgroundColor = .clear
        self.progressBar.trackFillColor = .orange.withAlphaComponent(0.3)
        self.progressBar.trackWidth = 2
        self.progressBar.centerFillColor = .clear
        
        self.addSubview(self.progressBar)
        
        if axis == .vertical {
         
            self.progressBar.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(10)
                make.width.equalTo(self.progressBar.snp.height)
            }
        }
        else {
            
            self.progressBar.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(10)
                make.width.equalTo(self.progressBar.snp.height)
            }
        }
    }
}
