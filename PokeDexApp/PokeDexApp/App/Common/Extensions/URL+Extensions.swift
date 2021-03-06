//
//  URL+Extensions.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 06/03/21.
//

import Foundation

extension URL{
    func getQueryStringParameter(param: String) -> String? {
      guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
      return urlComponents.queryItems?.first(where: { $0.name == param })?.value
    }
}
