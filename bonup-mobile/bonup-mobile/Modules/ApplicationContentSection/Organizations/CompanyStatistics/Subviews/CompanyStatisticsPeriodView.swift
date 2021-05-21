//
//  CompanyStatisticsPeriodView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import DatePicker

final class CompanyStatisticsPeriodView: UIView {
    
    enum DateType {
        
        case from, to
    }
    
    // MARK: - Private variables
    
    private lazy var dateFormatter = Date.dateFormatter
    
    // MARK: - UI variables
    
    private var fromLabel: UILabel!
    private var toLabel: UILabel!
    private var arrowImageView: UIImageView!
    
    // MARK: - Data variables
    
    private var fromDate: Date? {
        
        didSet {
            
            guard let date = fromDate else { return }
            
            self.fromLabel.text = self.dateFormatter.string(from: date)
        }
    }
    
    private var toDate: Date? {
        
        didSet {
            
            guard let date = toDate else { return }
            
            self.toLabel.text = self.dateFormatter.string(from: date)
        }
    }
    
    // MARK: - Public variables
    
    var onFromDateChange: ((Date) -> Void)?
    var onToDateChange: ((Date) -> Void)?
    
    // MARK: - Init
    
    init(fromDate: Date, toDate: Date) {
        
        super.init(frame: .zero)
        
        self.setupAppearance()
        self.setupSubviews()
        
        self.fromDate = fromDate
        self.setupDate(fromDate, to: self.fromLabel)
        
        self.toDate = toDate
        self.setupDate(toDate, to: self.toLabel)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.setupSectionStyle()
    }
    
    private func setupSubviews() {
        
        self.fromLabel = self.configureDateLabel()
        self.toLabel = self.configureDateLabel()
        
        let fromContainer = self.configureDateContainer(with: self.fromLabel, dateType: .from)
        let toContainer = self.configureDateContainer(with: self.toLabel, dateType: .to)
        self.arrowImageView = self.configureArrowImageView()
        
        self.addSubview(fromContainer)
        self.addSubview(self.arrowImageView)
        self.addSubview(toContainer)
        
        fromContainer.snp.makeConstraints { make in
            
            make.leading.top.bottom.equalToSuperview().inset(15)
        }
        
        self.arrowImageView.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            make.size.equalTo(50)
            make.leading.equalTo(fromContainer.snp.trailing).offset(15)
            make.trailing.equalTo(toContainer.snp.leading).offset(-15)
        }
        
        toContainer.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.size.equalTo(fromContainer)
            make.trailing.equalToSuperview().inset(15)
        }
        
        self.snp.makeConstraints { make in
            
            make.height.equalTo(80)
        }
    }
    
    // MARK: - Configure
    
    private func configureDateLabel() -> UILabel {
        
        let label = UILabel()
        
        label.theme_textColor = Colors.invertedTextColor
        label.font = .avenirHeavy(20)
        label.textAlignment = .center
        
        return label
    }
    
    private func configureDateContainer(with label: UILabel, dateType: DateType) -> UIView {
        
        let container = UIView()
        
        container.backgroundColor = .black.withAlphaComponent(0.14)
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: dateType == .to ? #selector(self.toDateTapped) : #selector(self.fromDateTapped))
        container.addGestureRecognizer(tapGesture)
        
        if dateType == .from {
            
            container.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
        else {
            
            container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        
        container.layer.cornerRadius = 13
        container.layer.masksToBounds = true
        
        return container
    }
    
    private func configureArrowImageView() -> UIImageView {
     
        let iv = UIImageView()
        
        if let image = AssetsHelper.shared.image(.rightArrow) {
            
            iv.image = image.withRenderingMode(.alwaysTemplate)
        }
        
        iv.theme_tintColor = Colors.defaultTextColor
        
        return iv
    }
    
    // MARK: - Selectors
    
    @objc private func toDateTapped() {
        
        guard let parentController = self.parentViewController else { return }
        
        let datePicker = DatePicker()
        datePicker.setup(beginWith: self.toDate,
                         min: self.fromDate ?? Date(),
                         max: Date(),
                         selected: { [weak self] selected, date in
            
            if selected, let date = date {
                
                self?.toDate = date
                
                self?.onToDateChange?(date)
            }
        })
        
        datePicker.show(in: parentController)
    }
    
    @objc private func fromDateTapped() {
        
        guard let parentController = self.parentViewController else { return }
        
        let datePicker = DatePicker()
        datePicker.setup(beginWith: self.fromDate,
                         min: DatePickerHelper.shared.dateFrom(day: 1, month: 1, year: 2020) ?? Date(),
                         max: self.toDate ?? Date(),
                         selected: { [weak self] selected, date in
            
            if selected, let date = date {
                
                self?.fromDate = date
                
                self?.onFromDateChange?(date)
            }
        })
        
        datePicker.show(in: parentController)
    }
    
    // MARK: - Helpers
    
    private func setupDate(_ date: Date?, to label: UILabel) {
        
        guard let date = date else { return }
        
        label.text = self.dateFormatter.string(from: date)
    }
}
