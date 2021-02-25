//
//  PokeAPI.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

class PokeAPI{
    func get(path: String, queryParams: [URLQueryItem]?, onSuccess: ((Data) -> Void)?, onErrorHandled: ((Error) -> Void)?){
        var components = URLComponents()
        components.scheme = "https"
        components.path = "pokeapi.co/api/v2/"
        components.path.append(path)
        components.queryItems = queryParams
        
        guard let url = components.url else {
            print("Unable to compose URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .useProtocolCachePolicy
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
//        sessionConfiguration.urlCache = cache
        
        URLSession(configuration: sessionConfiguration).dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let error = error {
                print("Network error: " + error.localizedDescription)
                onErrorHandled?(error)
//                onError?()
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Not a HTTP response")
//                onError?()
                return
            }
            guard response.statusCode == 200 else {
                print("Invalid HTTP status code \(response.statusCode)")
//                onError?()
                return
            }
            guard let data = data else {
                print("No HTTP data")
//                onError?()
                return
            }
            
            onSuccess?(data)
//            cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
//            onSuccess?(data)
        }).resume()
    }
    
    deinit {
            print("POKE API deinit")
    }
}
