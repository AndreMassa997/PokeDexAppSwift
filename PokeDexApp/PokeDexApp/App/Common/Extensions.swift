//
//  Extensions.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 26/02/21.
//

import UIKit

extension URL{
    func getQueryStringParameter(param: String) -> String? {
      guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
      return urlComponents.queryItems?.first(where: { $0.name == param })?.value
    }
}

extension UIImageView{
    func downloadFromUrl(from url: URL?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = url else { return }
        let cacheMemoryImages = URLCache(memoryCapacity: 0, diskCapacity: 200*1024*1024, diskPath: "PokeDexImagesCache")
        
        contentMode = mode
        if let data = cacheMemoryImages.cachedResponse(for: URLRequest(url: url))?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }else{
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
            sessionConfiguration.urlCache = cacheMemoryImages
            URLSession(configuration: sessionConfiguration).dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    cacheMemoryImages.storeCachedResponse(CachedURLResponse(response: httpURLResponse, data: data), for: URLRequest(url: url))
                    self?.image = image
                }
            }.resume()
        }
            
    }
}

