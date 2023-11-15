//
//  Webservice.swift
//  AsyncApp
//
//  Created by Айбек on 16.11.2023.
//

import Foundation

class Webservice {
    
    // SECOND SCENARIO
    /*func downloadCurrenciesAsyns(url : URL) async throws -> [CryptoCurrency] {
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data)
        return currencies ?? []
    }*/
    
    
    //THIRD SCENARIO
    func downloadcurrenciesContinuation(url : URL) async throws -> [CryptoCurrency] {
        try await withCheckedThrowingContinuation({ cont in
            downloadCurrencies(url: url) { res in
                switch res {
                case .success(let cryptos):
                    cont.resume(returning: cryptos ?? [])
                case .failure(let err):
                    cont.resume(throwing: err)
                }
            }
        })
    }
    
    // FIRST SCENARIO & THIRD SCENARIO
    func downloadCurrencies(url : URL, completion : @escaping(Result<[CryptoCurrency]?, DownloaderError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, responce, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.badUrl))
            }
            
            guard let data = data, error == nil else {
                return completion(.failure(.nodata))
            }
            
            guard let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data) else {
                return completion(.failure(.dataParseError))
            }
            
            completion(.success(currencies))
        }.resume()
    }

    
}

enum DownloaderError : Error {
    case badUrl
    case nodata
    case dataParseError
}
