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

class NetworkClient: ClientProtocol {
    private let manager: Alamofire.SessionManager
    private var baseURL = URL(string: AppUrl.BaseURL)!
    
    init(withSessionType type: SessionType = .defaultConfig) {
     manager = SessionConfiguration.getSessionManager(fromSessionType: type)
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
    case background
}

final class SessionConfiguration  {
    static func getSessionManager(fromSessionType type: SessionType) -> Alamofire.SessionManager {
        switch type {
        case .defaultConfig:
            return Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        case .ephemeral:
            return Alamofire.SessionManager(configuration: URLSessionConfiguration.ephemeral)
        case .background:
            return Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "###"))
        }
    }
}



typealias Parameters = [String: Any]
typealias Path = String
typealias Method = HTTPMethod

// MARK: Endpoint
final class Endpoint<Response:Decodable> {
    let method: Method
    let path: Path
    let parameters: Parameters?
    let parser: AnyParser<Response>!
    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil, parser: ParserType = .defaultParser) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.parser = Parser<Response>.getParser(fromType: parser)
    }
    
    init(method: Method = .get,
         path: Path,
         parameters: Encodable, parser: ParserType = .defaultParser) {
        self.method = method
        self.path = path
        self.parameters = parameters.dictionary
        self.parser = Parser<Response>.getParser(fromType: parser)
    }
}






