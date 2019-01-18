//
//  ViewModel.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 10/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire


enum NetworkClients {
    static let loginClient = NetWorkManager().createClient(withPath: "auth/authenticate", method: .post)
    static let building = NetWorkManager().createClient(withPath: "building", method: .get)
}


class ViewModel {
    private var loginService: Observable<NetworkClient>!
    private var buildingService: Observable<NetworkClient>!
    
    private let disposeBag = DisposeBag()
    var profileObserver = PublishSubject<UserProfile>()
    var errorMessage = PublishSubject<String>()
    
    init(networkCaller loginService: Observable<NetworkClient>, buildingService: Observable<NetworkClient>) {
        self.loginService = loginService
        self.buildingService = buildingService
    }
    
    func login() {
        
        _ = loginService.request(withParamerter: LoginRequest(username:"amar.smartmobe@gmail.com", password: "password")).parse(toType: BaseResponse<UserProfile>.self).subscribe(onSuccess: { (t) in
            print(t.body.debugDescription)
        }) { (e) in
            print(e.localizedDescription)
        }
    }
    
    
    
    
    func getbuildingInfo() {
        _ = buildingService.request().parse(toType: BaseResponse<NullResponse>.self).subscribe(onSuccess: { (data) in
            print(data.body.debugDescription)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
