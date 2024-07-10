//
//  http.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/24.
//

import Foundation
import SwiftUI
import Moya
import HandyJSON

struct HTTP {
    @AppStorage(AppStoreKeys.TOKEN) private var TOKEN: String?
    private let BASEURL: String = AppConfig.BASEURL
    
    func get(path: String, paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        var address = path
        
        if !path.starts(with: "http") {
            address = BASEURL + address
        }
        var i = 0
        
        if let paras = paras {
            for (key,value) in paras {
                if i == 0 {
                    address += "?\(key)=\(value)"
                }else {
                    address += "&\(key)=\(value)"
                }
                i += 1
            }
        }
        
        let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, respond, error) in
            if let data = data {
                if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    success(result)
                }
            }else {
                failure(error!)
            }
        }
        dataTask.resume()
    }
}


///网络请求基类, 基类参数基本固定
class JDBaseAPI {
    @AppStorage(AppStoreKeys.TOKEN) private var token: String?
    
    //请求域名
    let requestBaseUrl = AppConfig.BASEURL
    
    //请求公参, 理论上固定, 不可修改, plantform , version 等
    var requestCommenParam: [String: Any] {
        get {
            return [:]
        }
    }
    
    //请求 header , 理论上固定,  不可修改
    var requestHeader: [String: String]? {
        get {
            return ["Content-Type": "application/json", "charset": "utf-8", "token": token ?? ""]
        }
    }
    //请求超时时间
    var requestTimeOut = 10.0

}

class JDAPI: JDBaseAPI {
    //请求路径
    var requestPath: String?
    //请求形参
    var requestParam: [String: Any]?
    //请求方法, 默认 get
    var requestMethod: Moya.Method = .get
}

extension JDAPI: TargetType {
    ///域名
    var baseURL: URL { return URL(string: requestBaseUrl)! }
    ///路径
    var path: String {
        guard let requestPath = requestPath else { return "" }
        return requestPath
    }
    ///请求方法
    var method: Moya.Method {
        return requestMethod
    }
    ///请求任务, 在此合并公参
    var task: Task {
        //合并请求参数与公参
        var param: [String: Any] = [:]
        //先合并公参
        param.merge(requestCommenParam) { return $1 }
        //再合并形参, 如果形参中也有公参相同参数, 会覆盖掉公参, 以形参为主
        if let requestParam = requestParam {
            param.merge(requestParam) { return $1 }
        }
        
        if method == Moya.Method.get {
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        } else {
            return .requestCompositeParameters(bodyParameters: param, bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }
    ///header
    var headers: [String : String]? {
        return requestHeader
    }
}

//最外层结果
private class JDBaseRequestResult: HandyJSON {
    var charge: Int?
    var code: Int? // 200表示请求成功
    var msg: String?
    //数据结果
    var data: [String: Any]?
    required init() {}

}

///管理所有模块, 私有方法, 子请求通过 extension 实现
class JDRequestManager {
    /// 所有模块均通过此方法请求数据
    /// - **Parameters**:
    ///   - path: 路径（可自动填充base url）
    ///   - method: method
    ///   - param: 参数
    ///   - success: 请求结果, 成功或者失败都通过此闭包回调
    ///   - failure:
    static func JDRequestModule<T: HandyJSON>(path: String, method: Moya.Method = .get, param: [String: Any]?,
                                              success: @escaping ((_ succeed: Bool, _ data: T?) -> Void),
                                              failure: @escaping ((_ code: Int, _ msg: String?) -> Void)) {
        //API
        let api = JDAPI()
        api.requestPath = path
        api.requestParam = param
        api.requestMethod = method
        //设置超时
        let timeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<JDAPI>.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = api.requestTimeOut
                done(.success(request))
            } catch {
                return
            }
        }
        let provider = MoyaProvider<JDAPI>(requestClosure: timeoutClosure)
        provider.request(api) { result in
            //处理结果
            self.handleResult(result: result, success:success, failure: failure)
        }
    }
    
    
    private static func handleResult<T: HandyJSON>(result:Swift.Result<Moya.Response, MoyaError>,
                                                   success: @escaping ((_ succeed: Bool, _ data: T?) -> Void),
                                                   failure: @escaping ((_ code: Int, _ msg: String?) -> Void)){
        switch result {
        case .success(let response):
            let dic = try? response.mapJSON() as? Dictionary<String, Any>
            let result = JDBaseRequestResult.deserialize(from: dic)
            //过滤状态码, 200 为请求正常, 401, 需要登录等业务
            if result?.code == 200, let value = T.deserialize(from: result?.data) {
                //回调到数据层
                success(true, value)
            }else {
                //打印请求错误信息
                failure(result?.code ?? 0, result?.msg)
            }
            //方便调试,打印请求信息
            if let request = response.request,
               let method = request.method,
               let json = String(data: response.data, encoding: .utf8){
                print("~~~~~~~~~~~Request Start~~~~~~~~~~~~")
                print("Method:\(method.rawValue)\nURL:\(request)\nBody:\(String(describing: request.httpBody))\nResult:\n\(json)")
                print("~~~~~~~~~~~Request End~~~~~~~~~~~~")
            }
        case .failure(let error):
            //网络错误
            print(error)
            failure(0, nil)
        }
    }
}
