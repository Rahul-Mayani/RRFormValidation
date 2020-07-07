//
//  RRFormModel.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 06/07/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation

class RRFormModel: Codable {
    
    var name: String = ""
    var email: String = ""
    var mobile: String = ""
    var password: String = ""
    var countryCode: String = ""

    convenience init(name: String, email: String, mobile: String, password: String, countryCode: String) {
        self.init()
        self.name = name
        self.email = email
        self.mobile = mobile
        self.password = password
        self.countryCode = countryCode
    }
}
