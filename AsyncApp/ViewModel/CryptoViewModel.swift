//
//  CryptoViewModel.swift
//  AsyncApp
//
//  Created by Айбек on 16.11.2023.
//

import Foundation
import Combine

class CryptoListViewModel : ObservableObject {
    
    let webservice = Webservice()
    @Published var cryptoList = [CryptoViewModel]()
    
    func downloadCryptos(url : URL) {
        webservice.downloadCurrencies(url: url) { res in
            switch res {
            case .failure(let err):
                print(err)
                
            case .success(let cryptos):
                if let cryptos = cryptos {
                    DispatchQueue.main.async {
                        self.cryptoList = cryptos.map(CryptoViewModel.init)
                    }
                }
            }
        }
    }
    
}

struct CryptoViewModel {
    
    let crypto : CryptoCurrency
    
    var id : UUID? {
        crypto.id
    }
    
    var currency : String {
        crypto.currency
    }
    
    var price : String {
        crypto.price
    }
}
