//
//  ViewModel.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 10/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation
import RxSwift
struct NetworkClients {
    static let loginClient = NetWorkManager().createClient(withPath: "auth/authenticate", method: .post)
}
class ViewModel {
    private let loginCient: Observable<NetworkClient>!
    private let disposeBag = DisposeBag()
    var profileObserver = PublishSubject<UserProfile>()
    var errorMessage = PublishSubject<String>()
   
    init(networkCaller caller: Observable<NetworkClient>) {
        loginCient = caller
    }
    
    func login() {
        loginCient.subscribe(onNext: { (b) in
            
            print(b)
            
        }, onError: { (err) in
            print(err.localizedDescription)
        }).disposed(by: disposeBag)
    }
        
        
        
//        request(withParamerter: LoginRequest(username: "amar.smartmobe@gmail.com", password: "password")).parse(toType: BaseResponse<UserProfile>.self).subscribe(onSuccess: { (data) in
//            print(data.body!)
//        }) { (error) in
//            print(error.localizedDescription)
//        }.disposed(by: disposeBag)
//    }
    
//    func getHeatMapData() {
//        loginCient.request(API.ThirdParty.getDateTimeData()).subscribe(onSuccess: {[weak self] (data) in
//            print(data)
//        }) {[weak self] (error) in
//            self?.errorMessage.onNext(error.localizedDescription)
//            }.disposed(by: disposeBag)
//
//    }
}
