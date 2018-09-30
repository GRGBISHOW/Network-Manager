//
//  MockCreator.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 10/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
@testable import NetworkCaller

class TestBundle {
    func returnPath(forResource: String, ofType: String) -> String? {
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: forResource, ofType: ofType) {
            return path
        } else {
            return nil
        }
    }
}

class ObjectCreater {
    static func createObject(fromJSONFile fileName:String) -> Data {
        guard let path = TestBundle().returnPath(forResource: fileName, ofType: "json") else {
            fatalError("couldnt find path")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        return data
    }
}

class MockNetworkClient: NetworkClient {
    private let jsonFile:String!
    
    init(withJsonFile fileName: String) {
        jsonFile = fileName
    }
    
    @discardableResult
    override func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        return Single<Response>.create {[weak self] observer in
            let data = ObjectCreater.createObject(fromJSONFile: (self?.jsonFile)!)
            let result = Result<Data>.success(data)
            let dataResponse = DataResponse(request:URLRequest(url: URL(string: "http://abc.com")!), response: HTTPURLResponse(), data: Data(), result: result)
            let parsedError = endpoint.parser.parseResponse(withResponse: dataResponse)
            if let body = parsedError.0 {
                observer(.success(body))
            }else {
                observer(.error(parsedError.1!))
            }
            return Disposables.create()
        }
        
    }
}

