//
//  ViewController.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 5/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var thirdparty: UIButton!
    
    @IBAction func loginAction(_ sender: Any) {
        viewModel.login()
        //viewModel.getHeatMapData()
    }
    
    @IBAction func thirdPartyAction(_ sender: Any) {
       
    }
    
    
    var disposebag = DisposeBag()
    var viewModel:ViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = ViewModel(networkCaller: NetworkClients.loginClient)
        viewModel.profileObserver.subscribe(onNext: { profile in
            print(profile)
        }).disposed(by: disposebag)
       
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

