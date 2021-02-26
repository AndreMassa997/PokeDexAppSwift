//
//  PokeAPI.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

class PokeAPI{
    static let shared: PokeAPI = PokeAPI()
    
    //100 MB cache memory
    private let cacheMemory = URLCache(memoryCapacity: 0, diskCapacity: 100*1024*1024, diskPath: "PokeDexAPICache")
    
    func get(path: String, queryParams: [URLQueryItem]?, onSuccess: ((Data) -> Void)?, onErrorHandled: (() -> Void)?){
        
        //build the URL
        var components = URLComponents()
        components.scheme = "https"
        components.path = "pokeapi.co/api/v2/"
        components.path.append(path)
        components.queryItems = queryParams
        
        guard let url = components.url else {
            print("Unable to compose URL")
            return
        }
        
        //Build the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .useProtocolCachePolicy
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = cacheMemory
        
        if let cachedData = cacheMemory.cachedResponse(for: request)?.data{
            //if data are cached, means that are good
            print("Retrieve cached data for: \(request)")
            onSuccess?(cachedData)
        }else{
            print("Call service: \(request)")
            URLSession(configuration: sessionConfiguration).dataTask(with: request, completionHandler: { [weak self] data, response, error -> Void in
                if let error = error {
                    print("Network error: " + error.localizedDescription)
                    onErrorHandled?()
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Response invalid")
                    onErrorHandled?()
                    return
                }
                guard response.statusCode == 200 else {
                    print("Status code not valid: \(response.statusCode)")
                    onErrorHandled?()
                    return
                }
                guard let data = data else {
                    print("No data")
                    onErrorHandled?()
                    return
                }
                
                //store response and data in cache for offline usage
                self?.cacheMemory.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                onSuccess?(data)
            }).resume()
        }
    }
}
