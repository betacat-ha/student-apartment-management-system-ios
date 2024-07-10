//
//  AccountController.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/25.
//

import Foundation
import SwiftUI

class AccountController: ObservableObject {
    
    @AppStorage(AppStoreKeys.TOKEN) private var token: String?
    @AppStorage(AppStoreKeys.IS_LOGIN) private var isLogin: Bool?
    
    @Published var result: ServerResult = ServerResult()
    @Published var profileDetail: Account = Account()
    
    static var singleton = AccountController()
    
    func fecthProfile() {
        JDRequestManager.fecthProfile() { succeed, data in
            self.result.code = 200
            self.profileDetail = data!
        } failure: { code, msg in
            self.result.code = code
            self.result.msg = msg ?? "服务器开小差啦！"
        }
    }
    
    func login(phone: String, password: String, done: @escaping (_ result: ServerResult) -> Void) {
        JDRequestManager.requestToken(param: ["phone": phone, "password": password]) { succeed, data in
            self.result.code = 200
            self.token = data?.token
            self.isLogin = true
            done(self.result)
        } failure: { code, msg in
            self.result.code = code
            self.result.msg = msg ?? "服务器开小差啦！"
        }
    }
}

//模块枚举
enum AccountApiPath: String {
    case fecthProfile = "/mobile/profile"
    case login = "/auth/mobile-login"
}


extension JDRequestManager {
    //请求数据
    static func requestToken(param: [String: Any]?, 
                                success: @escaping ((_ succeed: Bool, _ data: Account?) -> Void),
                                failure: @escaping ((_ code: Int, _ msg: String?) -> Void)) {
        JDRequestModule(path: AccountApiPath.login.rawValue, method: .post, param: param, success: success, failure: failure)
    }
    
    //请求数据
    static func fecthProfile(success: @escaping ((_ succeed: Bool, _ data: Account?) -> Void),
                             failure: @escaping ((_ code: Int, _ msg: String?) -> Void)) {
        JDRequestModule(path: AccountApiPath.fecthProfile.rawValue, method: .get, param: [:], success: success, failure: failure)
    }
}
