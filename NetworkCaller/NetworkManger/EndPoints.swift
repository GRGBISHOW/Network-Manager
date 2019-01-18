//
//  EndPoints.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 6/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

typealias RxResponse = (HTTPURLResponse, Data)
extension ObservableType where E == NetworkClient {
    func request(withParamerter parameter: Encodable? = nil)  -> Observable<RxResponse>{
        return self.flatMap { (client) ->  Observable<RxResponse> in
            return client.manager.rx.request(client.endpoint.method, client.endpoint.url, parameters: parameter?.dictionary, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200...300).responseData()
            }
    }
    
    private func parse(error err: Error) throws {
        switch err._code {
        case NSURLErrorNotConnectedToInternet:
            throw NetworkError.notConnectedToInternet
        case NSURLErrorTimedOut:
            throw NetworkError.timeOut
        case NSURLErrorCancelled:
            throw NetworkError.cancelled
        case NSURLErrorBadURL:
            throw NetworkError.badUrl
        case NSURLErrorNetworkConnectionLost:
            throw NetworkError.networkConnectionLost
        case NSURLErrorResourceUnavailable:
            throw NetworkError.networkResourceUnavailable
        default :
            print("data error")
        }
        
        
    }
    
}


extension ObservableType where E == RxResponse {
    func parse<T:Decodable>(toType type: T.Type? = nil) -> Single<T>  {
        return self.map({ (response) -> T in
            do {
                let responseModel = try JSONDecoder().decode(T.self,from:response.1)
                return responseModel
            } catch let err {
                print(err.localizedDescription)
                throw err
            }
        }).asSingle()
        
    }
    
}




