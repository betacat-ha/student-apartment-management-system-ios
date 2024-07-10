//
//  Account.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/25.
//

import Foundation
import HandyJSON

class Account: HandyJSON {
    var id = ""
    var apartmentId = 0
    var className = ""
    var name = ""
    var age = 0
    var gender = ""
    var phone = ""
    var email = ""
    var status = 0
    var token = ""
    required init() {}
}
