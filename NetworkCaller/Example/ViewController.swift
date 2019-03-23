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
   
    @IBOutlet weak var userDataTable: UIStackView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBAction func loginAction(_ sender: Any) {
        viewModel.getUserData()
        //
    }
    
    
    
    var disposebag = DisposeBag()
    var viewModel:ViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userDataTable.isHidden = true
        viewModel = ViewModel(networkCaller: NetworkClients.userDataService) // Should be injected from outside while initilizating view controller
        viewModel.profileObserver.subscribe(onNext: {[weak self] profile in
            self?.userIdLabel.text = "\(profile.id)"
            self?.userNameLabel.text = profile.name
            self?.dobLabel.text = "\(profile.year)"
            self?.userDataTable.isHidden = false
        }).disposed(by: disposebag)
       
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

