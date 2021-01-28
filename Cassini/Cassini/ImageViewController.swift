//
//  ViewController.swift
//  Cassini
//
//  Created by Admin1 on 24/11/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {


    var imageURL: URL?{
        //archivo tipo url de internet o local
        didSet{
            //si alguien setea este opcional la imagen vuelve a nil, se chequea que la view(view.window) este en pantalla y se llama a la funcion fecthImage() para obtener la imagen del url imageURL
            image = nil
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    private var image: UIImage?{
        //retorna y le da un nuevo valor a la propiedad image de la variable imageView
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit() //se llama sizeToFit para darle a la imagen el mejor tamaño para que encaje
            scrollView?.contentSize = imageView.frame.size // se iguala el tamaño del contentSize al de los marcos de la imagen (frame.size) para que pueda scrollear. Tambien se coloca el scrollView como opcional (optional Chaining) para evitar crashes cada vez que hacemos un segue desde CassiniViewController.
            spinner?.stopAnimating() //Se coloca como opcional para evitar crashes despues de un segue
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil{
            //ni bien la view este en pantalla se llama fetchImage para buscar la imagen
            fetchImage()
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        //una vez que se inicializa el scrollview se añade como subview la variable imageView, se le da una escala para el zoom y se setea a self (esta view) como el delegado, para eso se añade arriba al lado de UIViewController UIScrollViewDelegate
        didSet{
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //se usa esta funcion para retornar el imageView que queremos que se transforme cada vez que hacemos zoom
        return imageView
    }
    
    //la imageView se declara en codigo, no se arrastra en el mainStoryboard
    var imageView =  UIImageView()
    
    private func fetchImage(){
        if let url = imageURL{
            //si imageURl esta seteado se intenta obtener la imagen del url
            spinner.startAnimating() //se inicia el activity indicator para indicar que esta cargando la imagen
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                //se utiliza un hilo en el background para evitar que el codigo que obtiene la url corra en el main(que prioriza la UI). Tambien se coloca weak self, por si el usuario cancela la operacion (ej: apretando back), asi esa imagen se elimina del heap (memoria).
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async{
                    //ahora se utiliza el hilo prinicipal para actualizar la ui, cosa que hace la propiedad computada image. Tambien nos fijamos si la constante url (la primera que declaramos dentro de esta funcion) es igual a imageURL en caso de que el usuario haya elegido otra imagen (cosa que cambiaria imageURL).
                    if let imageData = urlContents, url == self?.imageURL{
                        self?.image = UIImage(data: imageData) // self es opcional por [weak self]
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if imageURL == nil{
            //si cuando la vista carga imageURL es nil se carga una imagen de ejemplo
            image = #imageLiteral(resourceName: "Parque_Eagle_River,_Anchorage,_Alaska,_Estados_Unidos,_2017-09-01,_DD_02")
        }*/
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

