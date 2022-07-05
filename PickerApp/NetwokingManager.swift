//
//  NetwokingManager.swift
//  BTC-Core
//
//  Created by zhihong Meng on 2020/12/30.
//

import Foundation
import Alamofire

class NetwokingManager {
    
    typealias SuccessType = (_ result: Any?) -> Void
    typealias FailureType = (Error) -> Void
    
    private static let _instance: NetwokingManager = NetwokingManager()
    
//    private static let manager:  = {
//        let c = URLSessionConfiguration.default
//        c.httpMaximumConnectionsPerHost = 8
//
//    }()
    
    static var Instance: NetwokingManager {
        return _instance;
    }
    
    public class func request(method:HTTPMethod,URLString:String,parameters: [String:Any]?, success: SuccessType?, failure: FailureType?){
        
        let headers: HTTPHeaders = ["X-MBX-APIKEY": ""]
        
        AF.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result{
                case .success(let json):
                    guard success != nil else{
                        return
                    }
                    success!(json)
                    break
                case .failure(let error):
//                    print("error:\(error.localizedDescription)")
                    //注意这里有个token超时的问题
                    //todo: 处理401的问题 以及一些网络报错的提示
                    guard failure != nil else{
                        return
                    }
                    failure!(error)
                    break
            }
        })
       
    }
    
}
