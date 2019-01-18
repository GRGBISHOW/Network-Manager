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

typealias NetworkClient = (manager: SessionManager, endpoint: Endpoint)
protocol ClientCreatable {
    func createClient(withPath path:String, method:Method) -> Observable<NetworkClient>
}

class NetWorkManager: ClientCreatable {
    private var manager: Alamofire.SessionManager
    #if DEBUG
    private let url = NetWorkManager.devURL
    #elseif RELEASE
    private let url = NetWorkManager.uatURL
    #endif
    
    init(withSessionType type: SessionType = .defaultConfig) {
        manager = SessionConfiguration.getSessionManager(fromSessionType: type)
    }
    
    func createClient(withPath path: String, method: Method) -> Observable<NetworkClient> {
        return Observable.create({(observer) -> Disposable in
            //guard let slf = self else {return Disposables.create()}
            if let url = URL(string: self.url) {
                observer.on(.next((self.manager,Endpoint(method: method, url: self.getUrl(fromUrl: url, path: path)))))
                observer.on(.completed)
            }else {
                observer.on(.error(NetworkError.invalidURL))
            }
            return Disposables.create()
        })
    }
    
    private func appendPath(toBaseUrl url:URL, path: String) -> URL {
        return url.appendingPathComponent(path)
    }
    
    private func getUrl(fromUrl url: URL, path: String) -> URL{
        return path.contains("http") ? URL(string:path)! : appendPath(toBaseUrl: url, path: path)
    }

}

extension NetWorkManager {
    fileprivate static var devURL = ""
    fileprivate static var uatURL = ""
    
    
    enum BaseUrl {
        static func set(devURl url: String) {
            devURL = url
        }
        static func  set(uatURl url: String) {
            uatURL = url
        }
    }
}


enum SessionType {
    case defaultConfig
    case ephemeral
    case background(String)
}

final class SessionConfiguration  {
    private static let sharedDefaultInstance: Alamofire.SessionManager  = {
        return Alamofire.SessionManager.default
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
typealias Method = HTTPMethod

// MARK: Endpoint
class Endpoint {
    let method: Method
    let url: URL
    init(method: Method, url: URL) {
        self.method = method
        self.url = url
        
    }
}

extension HTTPMethod{
    var encodingType:ParameterEncoding{
        switch self{
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}




