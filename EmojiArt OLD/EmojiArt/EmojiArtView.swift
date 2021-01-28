//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Admin1 on 4/12/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit
//se crea la view en la que vamos a insertar la imagen de fondo, y a la que le vamos a soltar los emojis de la collectionView
class EmojiArtView: UIView, UIDropInteractionDelegate {

    
    override init(frame: CGRect){
        //inicializador UIView
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        //añadimos la interaccion UIDropInteraction (esto va a permitir soltarle los emojis de la collectionView a la imagen de fondo) y como delegado declaramos a esta UIView (self), declaramos el protoclo UIDropInteractionDelegate arriba, llamamos a esta funcion (setup()) en los dos inicializadroes arriba
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        //le decimos a la session (dropSession) puede cargar objetos de la clase NSAttributedString
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        //copiamos los emojis que arrastramos de la collectionView
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        //se le dice a la session (dropSession) que cargue los objetos (loadObjects) de cierta clase, que van a ser soltados en la imagen de fondo (en este caso los emonos)
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let dropPoint = session.location(in: self) //le pedimos al session (dragSession) el punto en el que callo este drop
            for attributedString in providers as? [NSAttributedString] ?? []{
                //pasamos a la funcion addLabel (delcarada mas abajo) todos los drop (attributedString (emojis)) que soltamos en la imagen y el dropPoint
                self.addLabel(with: attributedString, centeredAt: dropPoint)
            }
        }
    }
    
    func addLabel(with attributedString: NSAttributedString, centeredAt point: CGPoint){
        let label = UILabel()
        label.attributedText = attributedString
        label.backgroundColor = .clear
        label.sizeToFit()
        label.center = point
        addSubview(label) //se añade la label como subview de esta view
    }
    
    //declaramos una variable para la imagen de fondo y llamamos a setNeedDisplay cada vez que se setea para ajustar los marcos
    var backgorundImage: UIImage? { didSet { setNeedsDisplay() }}
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //se coloca (draw) la imagen backgroundImage dentro de los limites (bounds)
        backgorundImage?.draw(in: bounds)
    }
 

}
