# Network Manager

Network Manager is a network layer based on RxAlamofire and Alamofire. Network Manager is centralized class to do all the requests and manage errors in reactive way.

# Usage


``` Swift
enum NetworkClients {
    static let userDataService = NetWorkManager().createClient(withPath: "user/2", method: .get)
}
```

``` Swift
 func getUserData() {
        _ = userDataService.request().parse(toType: DataModel<User>.self).subscribe(onSuccess: { (model) in
            print(model.data)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
```
