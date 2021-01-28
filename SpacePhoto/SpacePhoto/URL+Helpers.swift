//
//  URL+Helpers.swift
//  SpacePhoto
//
//  Created by Admin1 on 2/10/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import Foundation

extension URL{
    func withQueries(_ queries: [String: String]) -> URL?{
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map
            {URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
    func withHTTPS() -> URL?{
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.scheme = "https"
        return components?.url
    }
    
}


