//
//  DocumentBrowserViewController.swift
//  EmojiArt
//
//  Created by Admin1 on 11/1/21.
//  Copyright © 2021 Admin1. All rights reserved.
//

import UIKit

//en Document Types dentro de info en la configracion del proyecto (hacer click en EmojiArt arriba de la carpeta EmojiArt en el project navigator) se dio el permiso de abrir archivos JSON 
class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        //se permite la creacion de documentos solo en el ipad
        if UIDevice.current.userInterfaceIdiom == .pad{
            //se le asigna el valor a la url template declarada mas abajo, se la crea en .applicationSupportDirectory (donde se declaran cosas que estan detras de escenas) ya que no queremos que un documento en blanco aparezca en los documentos, si el template no es nil se permite la creacion de documentos
            template = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true).appendingPathComponent("Untitled.json")
            if template != nil{
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
            }
        }
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var template: URL? //esta variable apunta a un documento en blanco
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
       //se le pasa al importHandler la var template declarada mas arriba que se le asigno el valor en viewvDidLoad, y se la copia de .applicationSupportDirectory al .documentDirectory
       importHandler(template, .copy)
        
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
  
    func presentDocument(at documentURL: URL) {
        //se usa el storyboard para obtener el vc que quiero presentar, para hacer esto hay que darle un identificador al navController que esta por delante del vc, se instancia el vc en la constante documentVC. Si el primer vc del navVC es un EmojiArtViewController (ver extension contents en  archivo utilities) se le asigna como valor a la var document del emojiArtViewController un EmojiArtDocument al que se le pasa la url que toma como parametro esta funcion
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "DocumentMVC")
        if let emojiArtViewController = documentVC.contents as? EmojiArtViewController{
            emojiArtViewController.document = EmojiArtDocument(fileURL: documentURL)
        }
        //se presenta de forma animada el vc
        present(documentVC, animated: true)
    }
 
}

