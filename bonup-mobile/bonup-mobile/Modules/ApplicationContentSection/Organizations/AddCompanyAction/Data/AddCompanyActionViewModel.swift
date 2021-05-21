//
//  AddCompanyActionViewModel.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

struct AddCompanyActionViewModel {
    
    var fieldType: CompanyActionFieldType
    var value: Any?
    
    let isModifieble: Bool
    
    init(with value: Any?,
         field type: CompanyActionFieldType,
         mode: AddCompanyActionDependency.Mode) {
        
        self.value = value
        self.fieldType = type
        
        self.isModifieble = mode != .read
    }
}
