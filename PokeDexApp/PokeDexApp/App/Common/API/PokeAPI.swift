//
//  PokeAPI.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

typealias APIResult = (Data?, ErrorData?) -> Void

final class PokeAPI{
    static let shared: PokeAPI = PokeAPI()
    
    //200 MB cache memory + 200 MB for images
    private let cacheMemory = URLCache(memoryCapacity: 0, diskCapacity: 200*1024*1024, diskPath: "PokeDexAPICache")
    
    func get(path: String, queryParams: [URLQueryItem]? = nil, saveResponseOnCache: Bool = true, onResult: @escaping APIResult){
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
        
        //Build the get request
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
            onResult(cachedData, nil)
        }else{
            URLSession(configuration: sessionConfiguration).dataTask(with: request, completionHandler: { [weak self] data, response, error -> Void in
                if let error = error {
                    print("Network error: " + error.localizedDescription)
                    onResult(nil, .networkError)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Response invalid")
                    onResult(nil, .invalidResponse)
                    return
                }
                guard response.statusCode == 200 else {
                    print("Status code not valid: \(response.statusCode)")
                    onResult(nil, .invalidStatusCode)
                    return
                }
                guard let data = data else {
                    print("No data")
                    onResult(nil, .invalidData)
                    return
                }
                
                //store response and data in cache for offline usage
                if saveResponseOnCache{
                    self?.cacheMemory.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                }
                onResult(data, nil)
            }).resume()
        }
    }
}

enum ErrorData: Error{
    case networkError
    case invalidData
    case invalidResponse
    case invalidStatusCode
}
