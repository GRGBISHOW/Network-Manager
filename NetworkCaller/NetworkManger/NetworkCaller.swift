//
//  NetworkCaller.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 6/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa
import RxAlamofire
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

struct AppUrl {
    
    private struct Domains {
        static let dev = "http://baseUrl.com"
        static let uat = "http://baseUrl.com"
        static let qa = ""
        static let produciton = ""
    }
    
    private  struct Routes {
        static let Api = "/api"
    }
    
    struct ThirdParty {
        static let jsonTest = "http://date.jsontest.com"
    }
    
    #if DEBUG
    private  static let domain = Domains.dev
    #elseif RELEASE
    private  static let domain = Domains.uat
    #endif
    
    private static let route = Routes.Api
    static var BaseURL = domain + route
   
}



protocol ClientProtocol {
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response>
}

protocol Requestable {
    func request<Response>(withPath path:String, method:Method) -> Reactive<SessionManager>
}

class NetWorkManager: Requestable {
    
    private var manager: Alamofire.SessionManager
    #if DEBUG
    private let url = NetWorkManager.devURL
    #elseif RELEASE
    private let url = NetWorkManager.uatURL
    #endif
    
    init(withSessionType type: SessionType = .defaultConfig) {
        manager = SessionConfiguration.getSessionManager(fromSessionType: type)
    }
    
    func request(withPath path: String, method: Method) -> Observable<(SessionManager,Endpoint)> {
        return Observable.create({ (observer) -> Disposable in
          
            
        })
    }
    
    private func appendPath(toBaseUrl path: String) -> URL {
        guard let url = URL(string: url) else {fatalError("Please provide valid url")}
        return url.appendingPathComponent(path)
    }
    
    private func getUrl(path: String) -> URL{
        return path.contains("http") ? URL(string:path)! : appendPath(toBaseUrl: path)
    }

    
    
    
}

extension NetWorkManager {
    fileprivate static var devURL = "https://google.com"
    fileprivate static var uatURL = "https://google.com"
    
    enum BaseUrl {
        static func set(devURl url: String) {
            devURL = url
        }
        static func  set(uatURl url: String) {
            uatURL = url
        }
    }
}


class NetworkClient: ClientProtocol {
    private static let manager: Alamofire.SessionManager
    
    private var baseURL = URL(string: AppUrl.BaseURL)!
    
    
    
    @discardableResult func caller(withPath path:String, method:Method, sessonType:SessionType = .defaultConfig) -> Single<Response> {
        
        
        
    }
    
     @discardableResult func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        return Single<Response>.create {observer -> Disposable in
            let request = self.manager.request(self.getUrl(path: endpoint.path),
                method: endpoint.method,
                parameters: endpoint.parameters, encoding: URLEncoding.default,
                headers: nil).validate(statusCode: 200...300)
            request.responseData() { response in
            
                    let parsedError = endpoint.parser.parseResponse(withResponse: response)
                    if let body = parsedError.0 {
                        observer(.success(body))
                    }else {
                        observer(.error(parsedError.1!))
                    }
                }
            
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func appendPath(toBaseUrl path: Path) -> URL {
         return baseURL.appendingPathComponent(path)
    }

    private func getUrl(path:Path) -> URL{
        return path.contains("http") ? URL(string:path)! : appendPath(toBaseUrl: path)
    }
    
}



enum SessionType {
    case defaultConfig
    case ephemeral
    case background(String)
}

final class SessionConfiguration  {
    private static let sharedDefaultInstance: Alamofire.SessionManager  = {
        return Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    }()
    private static let sharedEphemeralInstance: Alamofire.SessionManager = {
        return Alamofire.SessionManager(configuration: URLSessionConfiguration.ephemeral)
    }()
   
    static func getSessionManager(fromSessionType type: SessionType) -> Alamofire.SessionManager {
        switch type {
        case .defaultConfig:
            return sharedDefaultInstance
        case .ephemeral:
            return sharedEphemeralInstance
        case .background(let identifier):
            return Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: identifier))
        }
    }
}



typealias Parameters = [String: Any]
typealias Path = String
typealias Method = HTTPMethod

// MARK: Endpoint
class Endpoint {
    let method: Method
    let url: URL
    let parameters: Parameters?
   
    init(method: Method, url: URL) {
        self.method = method
        self.url = url
        
    }
}






