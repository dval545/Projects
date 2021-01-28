//
//  Galleries.swift
//  ImageGalley
//
//  Created by Admin1 on 19/1/21.
//  Copyright © 2021 Admin1. All rights reserved.
//

import Foundation

struct Galleries: Codable{
    var urlOfImages: [URL]
    
    var json: Data?{
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(Galleries.self, from: json){
            self = newValue
        } else{
            return nil
        }
    }
    
    init(urlOfImages: [URL]) {
        self.urlOfImages = urlOfImages
    }
}
