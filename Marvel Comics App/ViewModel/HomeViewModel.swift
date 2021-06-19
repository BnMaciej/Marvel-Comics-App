//
//  HomeViewModel.swift
//  Marvel Comics App
//
//  Created by Maciej Banaszyński on 18/06/2021.
//

import SwiftUI
import Combine
import CryptoKit

class HomeViewModel: ObservableObject{
    
    @Published var searchedQuery = ""
    
    
    var searchCancellable: AnyCancellable? = nil
    
    @Published var fetchedComics: [Comic]? = nil
    
    @Published var fetchComics: [Comic] = []
    
    @Published var offset: Int = 0
    
    init(){
        
        searchCancellable = $searchedQuery
            .removeDuplicates()
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                
                if str == "" {
                    
                    self.fetchedComics = nil
                    
                }
                else{
                    
                    self.searchComics()
                    
                }
            })
        
        
    }
    
    func searchComics(){
        
        let ts=String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        let originalQuery = searchedQuery.replacingOccurrences(of: " ", with: "%20")
        
        let url="https://gateway.marvel.com:443/v1/public/comics?titleStartsWith=\(originalQuery)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        

        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if let error = err{
                print("Session Error: ",error.localizedDescription)
                return
            }
            
            guard let APIData = data else{
                print("No data found")
                return
            }
            
            do{
                
                let comics = try JSONDecoder().decode(APIResult.self, from: APIData)
                
                DispatchQueue.main.async {
                    
                    if self.fetchedComics == nil{
                        self.fetchedComics = comics.data.results
                    }
                    
                }
                
            }
            catch{
                print("SessionError: ", error.localizedDescription)
            }
        }
        .resume()
        
    }
    
    func MD5(data: String) -> String{
        
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hash.map{
            String(format: "%02hhx", $0)
        }
        .joined()
    }
    
    func fetchAllComics(){
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        let url = "https://gateway.marvel.com:443/v1/public/comics?limit=20&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            guard let APIData = data else{
                print("no data found")
                return
            }
            
            do{
                
                let comics = try JSONDecoder().decode(APIResult.self, from: APIData)
                
                DispatchQueue.main.async {
                    self.fetchComics.append(contentsOf: comics.data.results)
                }
                
            }
            catch{
                print(error.localizedDescription)
            }
        }
        .resume()
        
    }
}
