//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Admin1 on 6/1/21.
//  Copyright © 2021 Admin1. All rights reserved.
//

import Foundation

struct EmojiArt: Codable{
    var url: URL
    var emojis = [EmojiInfo]()
    
    struct EmojiInfo: Codable {
        //EmojiInfo toma la posicion X e Y de los emojis que soltamos en la imagen de fondo, el texto es el emoji y el size es el tamaño de la fuente
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    var json: Data?{
        //se codifica los datos del EmojiArt en un json
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        //se declara este failable initialaizer para decodificar los datos de un json y transformarlos en un EmojiArt, en caso de que no se pueda se retorna nil
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json){
            self = newValue
        } else {
            return nil
        }
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
}
