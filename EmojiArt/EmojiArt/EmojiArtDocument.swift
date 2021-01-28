//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Admin1 on 11/1/21.
//  Copyright © 2021 Admin1. All rights reserved.
//

import UIKit

class EmojiArtDocument: UIDocument {
    
    var emojiArt: EmojiArt?
    var thumbnail: UIImage? 

    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper (retorna un Any y no un Data por que puede ser un FileWrapper)
        //retorna el json del emojiArt, si no hay uno retorna un data vacio 
        return emojiArt?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let json = contents as? Data{
            emojiArt = EmojiArt(json: json)
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
        //se usa para crear un thumbnail
        //retorna un diccionario de los attributos del archivo, se obtiene esos atributos de la supercalss
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail{
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes
    }
}

