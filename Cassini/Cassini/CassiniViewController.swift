//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Admin1 on 30/11/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {


    // MARK: - Navigation - Este view controller se usa para elegir la foto que el ImageViewController va a mostrar
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier{
            //se le pasa el identifier como clave al diccionario NASA dentro de el struct DemoURLs
            if let url = DemoURLs.NASA[identifier]{
                //una vez obtenida la url del diccionario se llama al ImageViewController y se la pasa a la variable imageURL de ImageViewController, tambien se le pone como titulo a ImageViewController (que tiene un navigationViewController) el nombre del boton que mando el segue.
                
                /*//(se le puso un navController a este VC para que pueda tener un titulo el detail en ipad)se declara la var destination igual a segue.destination, despues declaramos la constante navocn para chequear el destino es un NavigationController, si es asi el destino es el visibleViewController de navcon si es que hay alguno.
                var destination = segue.destination
                if let navcon = destination as? UINavigationController{
                    destination = navcon.visibleViewController ?? navcon
                }*/
                if let ImageVC = segue.destination.contents as? ImageViewController{
                    //llamamos a la variable contents de la extension que hicimos mas abajo
                    ImageVC.imageURL = url
                    ImageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
        
    }
    
}

extension UIViewController{
    //esta extension se usa para retornar el visibleViewController de un navigationController (si es que hay uno). Se le puso un navController a este VC para que pueda tener un titulo el detail en ipad
    var contents: UIViewController{
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}




