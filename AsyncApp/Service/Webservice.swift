//
//  Webservice.swift
//  AsyncApp
//
//  Created by Айбек on 16.11.2023.
//

import Foundation

class Webservice {
    
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
