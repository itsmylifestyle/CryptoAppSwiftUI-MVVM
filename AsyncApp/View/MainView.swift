//
//  ContentView.swift
//  AsyncApp
//
//  Created by Айбек on 15.11.2023.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var cryptoListViewModel : CryptoListViewModel
    
    init() {
        self.cryptoListViewModel = CryptoListViewModel()
    }
    
    var body: some View {
        NavigationView {
            List(cryptoListViewModel.cryptoList, id:\.id) { crypto in
                VStack {
                    Text(crypto.currency).font(.title2).foregroundColor(.black).frame(maxWidth: .infinity, alignment: .leading)
                    Text(crypto.price).foregroundColor(.green).frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .toolbar(content: {
                Button {
                    Task.init {
                        await cryptoListViewModel.downloadCryptosCont(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
                    }
                } label: {
                    Text("Refresh")
                }

            })
            .navigationTitle(Text("Crypto Crazy"))
        }.task {
            
            await cryptoListViewModel.downloadCryptosCont(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
            
            //SECOND SCENARIO
            //await cryptoListViewModel.downloadCryptoAsync(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
        }
        
        
        /*.onAppear {       FIRST SCENARIO
            cryptoListViewModel.downloadCryptos(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
        }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
