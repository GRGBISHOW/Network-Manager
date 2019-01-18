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
    static let userDataService = NetWorkManager().createClient(withPath: "user/2", method: .get)
}


class ViewModel {
    private var userDataService: Observable<NetworkClient>!
  
    
    private let disposeBag = DisposeBag()
    var profileObserver = PublishSubject<User>()
    var errorMessage = PublishSubject<String>()
    
    init(networkCaller userDataService: Observable<NetworkClient>) {
        self.userDataService = userDataService
    }
    
    
    func getUserData() {
        _ = userDataService.request().parse(toType: DataModel<User>.self).subscribe(onSuccess: { (data) in
            print(data.data)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
