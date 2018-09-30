//
//  NetworkCallerTests.swift
//  NetworkCallerTests
//
//  Created by Gurung Bishow on 5/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import XCTest
import RxSwift
@testable import NetworkCaller

class ViewModelTests: XCTestCase {
    var disposebag: DisposeBag!
    var sut:ViewModel!
    override func setUp() {
        super.setUp()
        disposebag = DisposeBag()
        sut = ViewModel(networkCaller: MockNetworkClient(withJsonFile: "LoginResponse"))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_login() {
        sut.profileObserver.subscribe(onNext: { profile in
            XCTAssertEqual(profile.id, 3)
            }).disposed(by: disposebag)
        sut.login()
    }

}
