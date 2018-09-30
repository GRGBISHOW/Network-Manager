//
//  ViewModel.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 10/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation
import RxSwift
class ViewModel {
    private let loginCient: NetworkClient!
    private let disposeBag = DisposeBag()
    var profileObserver = PublishSubject<UserProfile>()
    var errorMessage = PublishSubject<String>()
   
    init(networkCaller caller: NetworkClient) {
        loginCient = caller
    }
    
    func login() {
        loginCient.request(API.Auth.login(name: "example@gmail.com", password: "123456")).subscribe(onSuccess: {[weak self] (profile) in
            //print(profile)
            self?.profileObserver.onNext(profile)
        }) {[weak self] (error) in
            self?.errorMessage.onNext(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
    
    func getHeatMapData() {
        loginCient.request(API.ThirdParty.getDateTimeData()).subscribe(onSuccess: {[weak self] (data) in
            print(data)
        }) {[weak self] (error) in
            self?.errorMessage.onNext(error.localizedDescription)
            }.disposed(by: disposeBag)
        
    }
}
