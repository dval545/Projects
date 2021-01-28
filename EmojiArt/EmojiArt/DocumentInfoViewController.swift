//
//  DocumentInfoViewController.swift
//  EmojiArt
//
//  Created by Admin1 on 21/1/21.
//  Copyright © 2021 Admin1. All rights reserved.
//

import UIKit
//se usa este VC para mostrar la fecha de creacion del documento, su tamaño y el thumbnail en un VC presentado con show modally, en un popover y en un containerView 
class DocumentInfoViewController: UIViewController {
    
    
    // MARK: - Model
    var document: EmojiArtDocument? {
        didSet{
            updateUI()
        }
    }
    
    
    override func viewDidLoad() {
        //tambien se actualiza la UI en viewDidLoad ademas de cuando se setea el document por si los outlets todavia no se setearon
        updateUI()
    }
    
    
    @IBOutlet weak var topLevelView: UIStackView!
    @IBOutlet weak var thumbnailAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    
    private let dateFormatter: DateFormatter = {
        //se declara un DateFormatter(), se le da un dataStyle y un timeStyle .short
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }() //se cierra con parentesis porque es un clousure
    
    private func updateUI(){
        //se chequea que los outlets sizeLabel y createLabel esten seteados (que no sean nil), se pide la url del document en la constante url, se declara la constante attributes para obtener los atributos de la url, se setea el texto del sizeLabel con el tamaño del archivo (se le pasa [.size] a attributes ya que es un array de FileAttributesKey) si es nil se le pone 0. Se setea el texto del createLabel con el dateFormatter declarado arriba
        if sizeLabel != nil, createdLabel != nil,
            let url = document?.fileURL,
            let attributes = try? FileManager.default.attributesOfItem(atPath: url.path){
            sizeLabel.text = "\(attributes[.size] ?? 0) bytes"
            if let created = attributes[.creationDate] as? Date {
                createdLabel.text = dateFormatter.string(from: created)
            }
        }
        if thumbnailImageView != nil, thumbnailAspectRatio != nil, let thumbnail = document?.thumbnail{
            //se setea el thumbnail del document como el thumbnailImageView, se elimina la restriccion thumbnailAspectRatio (que es de solo lectura, si queremos modificarla para que se adapte al thumbnail actual tenemos que eliminarla y asignarle un nuevo valor), se le da un nuevo valor a la restriccion thumbnailAspectRatio tomando como item el thumbnailImageView y sus atributos. Se añade la restriccion al thumbnailImageView
            thumbnailImageView.image = thumbnail
            thumbnailImageView.removeConstraint(thumbnailAspectRatio)
            thumbnailAspectRatio = NSLayoutConstraint(
                item: thumbnailImageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .height,
                multiplier: thumbnail.size.width / thumbnail.size.height,
                constant: 0)
            thumbnailImageView.addConstraint(thumbnailAspectRatio)
        }
        //si fuimos presentados a traves de un popover, escondemos el thumbnailImageView, el returnButton y seteamos el color de fondo como claro
        if presentationController is UIPopoverPresentationController {
            thumbnailImageView?.isHidden = true
            returnButton?.isHidden = true
            view.backgroundColor = .clear
        }
    }
    
    //cambiamos el tamaño default del popover por un tamaño comprimido
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //en viewDidLayoutSubviews es donde se hacen los cambios en el contentSize. Para cambiar el tamaño del contentSize se hizo un outlet del topLevelView (el primer stackView). Se declara la constante fittedSize a la cual el valor que se le asigna es el tamaño comprimido del topLevelView. Se setea el preferredContentSize igual al fittedSize mas 30 para agregarle un poco de espacio
        if let fittedSize = topLevelView?.sizeThatFits(UILayoutFittingCompressedSize){
            preferredContentSize = CGSize(width: fittedSize.width + 30, height: fittedSize.height + 30)
        }
    }
    
    @IBAction func returnToDocument() {
        //se le pide al vc que presento este vc que lo quite 
        presentingViewController?.dismiss(animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
