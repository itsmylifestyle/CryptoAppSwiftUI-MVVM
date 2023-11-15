//
//  CryptoViewModel.swift
//  AsyncApp
//
//  Created by Айбек on 16.11.2023.
//

import Foundation
import Combine

@MainActor
class CryptoListViewModel : ObservableObject {
    
    let webservice = Webservice()
    @Published var cryptoList = [CryptoViewModel]()
    
    
    func downloadCryptosCont(url : URL) async {
        do {
            let ctyptos = try await webservice.downloadcurrenciesContinuation(url: url)
            self.cryptoList = ctyptos.map(CryptoViewModel.init)
            
            /*DispatchQueue.main.async {
                self.cryptoList = ctyptos.map(CryptoViewModel.init)
            }*/ //we removed it because I used @MainActor and this helps ...(check your notes)
        } catch {
            print(error)
        }
    }
    
    /* SECOND SCENARIO
    func downloadCryptoAsync(url : URL) async {
        do {
            let cryptos = try await webservice.downloadCurrenciesAsyns(url: url)
            DispatchQueue.main.async {
                self.cryptoList = cryptos.map(CryptoViewModel.init)
            }
        } catch {
            print(error)
        }
    }
     */
    
    /*  FIRST SCENARIO 
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
     */
    
    
    
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
