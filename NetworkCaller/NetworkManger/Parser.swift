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
            return client.manager.rx.request(client.endpoint.method, client.endpoint.url, parameters: parameter?.dictionary, encoding: client.endpoint.method.encodingType , headers: nil).validate(statusCode: 200...300).responseData()
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
                throw err // You can parse the err by passing error to exception, You have to add the enum in exception
            }
        }).asSingle()
        
    }
    
}




