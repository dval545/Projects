//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Admin1 on 4/12/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

extension EmojiArt.EmojiInfo{
    //se añade una init? a EmojiInfo (ver archivo EmojiArt) que toma una label como argumento de la cual se toma su posicion texto y tamaño en la imagen de fondo, si no puede retornar los datos se retorna nil (failable initialaizer)
    init?(label: UILabel){
        if let attributedText = label.attributedText, let font = attributedText.font{
            x = Int(label.center.x)
            y = Int(label.center.y)
            text = attributedText.string
            size = Int(font.pointSize)
        } else {
            return nil
        }
    }
}


class EmojiArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    
    // MARK: - Model
   
    var emojiArt: EmojiArt? {
        //se declara el modelo como una propiedad computada, cada vez que alguien llame al modelo, se mira la UI y se lo forma, y se setea cada vez que se actualiza la UI
        get{
            if let url = emojiArtBackgroundImage.url{
                //se obtiene un array de labels (flatMap es como map solo que devuelve nil si no hay labels) del cual se obtiene un array de EmojiInfo
                let emojis = emojiArtView.subviews.flatMap { $0 as? UILabel }.flatMap { EmojiArt.EmojiInfo(label: $0) }
                return EmojiArt(url: url, emojis: emojis)
            }
            return nil
        }
        set{
            //se elimina la imagen y los emojis (labels) que estaban antes de setear el nuevo modelo
            emojiArtBackgroundImage = (nil, nil)
            emojiArtView.subviews.flatMap {$0 as? UILabel}.forEach { $0.removeFromSuperview() }
            //se busca la nueva url (EmojiArt tiene una variable url por eso newValue?.url)
            if let url = newValue?.url{
                imageFetcher = ImageFetcher(fetch: url) { (url, image) in
                    DispatchQueue.main.async {
                        self.emojiArtBackgroundImage = (url, image)
                        newValue?.emojis.forEach{
                            //se le pide a cada emoji (EmojiArt tiene una variable emojis) su texto, su tamaño, su posicion y se lo añade al emojiArtView. La funcion attributedString esta declarada en utilities (transforma el texto en attributedString)
                            let attributedText = $0.text.attributedString(withTextStyle: .body, ofSize: CGFloat($0.size))
                            self.emojiArtView.addLabel(with: attributedText, centeredAt: CGPoint(x: $0.x, y: $0.y))
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        //Se declara una url en .documentDirectory (ya que estamos trabajando con un documento), luego se añade el nombre del archivo a ese directorio ("Untitled.json"). Se hace un try catch cuando se intenta salvar el json ya que puede ocurrir un error. (se añadio en Info.plist Supports Document Browser, que le dice al sistema que esta app puede tener acceso a .documentDirectory)
        if let json = emojiArt?.json{
            if let url = try? FileManager.default.url(for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true).appendingPathComponent("Untitled.json"){
                do{
                    try json.write(to: url)
                    print("saved successfully!")
                } catch let error{
                    print("couldn't save \(error)")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //se convierten los datos de la url donde se guardo el json en la funcion save (IBAction func save) en un emojiArt
        if let url = try? FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true).appendingPathComponent("Untitled.json"){
            if let jsonData = try? Data(contentsOf: url){
                emojiArt = EmojiArt(json: jsonData)
            }
        }
        
    }
    
    
    // MARK: - Storyboard
    //el dropZone es donde se van a soltar los emojis
    @IBOutlet weak var dropZone: UIView! {
        //añadimos una interaccion UIDropInteraction y declaramos como delegado a self (este view controller).
        didSet{
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    var emojiArtView = EmojiArtView() //esta variable la vamos a usar para colocar la imagen de fondo y los emojis sobre esa imagen
    
    //hacemos outlets de las restricciones width y height del scrollView para poder modificarlas desde el codigo
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            //se setean algunos metodos del srollView (para saber mas sobre scrollView ver proyecto Cassini)
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //se llama esta funcion una vez que se hizo zoom
        //seteamos el Height y el Width del scrollView igual al del contentSize (para eso hicimos outlets de las constraints (ver arriba)), para que la imagen se mantenga centrada cuando hacemos zoom (en la variable computada emojiArtBackgroundImage seteamos el contentSize igual al frame de el backgrounImage). Antes se seteo en el storyboard el top, leading, trailing y bottom space del scrollView como mayor o igual que el safe area y la prioridad de las restricciones height y width se marco como bajas (250)
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //retorna la vista en la que se va a hacer zoom
        return emojiArtView
    }
    
    private var _emojiBackgroundURL: URL? //el guion bajo significa que no vamos a setear esta variable directamente, la seteamos dentro de la variable emojiArtBackgroundImage
    
    var emojiArtBackgroundImage: (url: URL?, image: UIImage?){
        //Se declara esta variable como una tupla asi la url y la imagen de la url estan siempre sincronizados
        get{
            return (_emojiBackgroundURL, emojiArtView.backgorundImage)
        }
        set{
            _emojiBackgroundURL = newValue.url //se setea la nueva url
            scrollView?.zoomScale = 1.0 //si hay algun scrollView se seta el zoom 1.0 (tamaño normal de la imagen)
            emojiArtView.backgorundImage = newValue.image //se setea como backgroundImage la nueva imagen
            let size = newValue.image?.size ?? CGSize.zero //se obtiene el tamaño de la nueva imagen (si es que hay una), en caso de que no haya la constante size es 0
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size) //se pone como origen el angulo superior izquierdo (CGPoint.zero) y  setea el tamaño del marco del emojiArtView segun el valor de la constante size
            scrollView?.contentSize = size //seteamos el contentSize del scrollView? (si hay alguno) igual que el frame
            scrollViewHeight?.constant = size.height //se setea el Height del scrollView igual al de el frame
            scrollViewWidth?.constant = size.width ////se setea el Width del scrollView igual al de el frame
            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
            } //se setea el maximo zoomScale del scrollView dividiendo el width del dropZone por el width del size, lo mimso para el height
        }
    }
    //se mapea un string de emojis a un array de strings
    var emojis = "😀😃😄🐱🐶✈️🚗🐰🍕🍔🍎🍩🙂⚽️".map { String($0) }
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet{
            //siempre que se hace un outlet de un collectionView a un viewController que no es un collectionViewController, se setea self como el dataSource y el delegate, para eso añadimos arriba donde se declara la clase los protocolos UICollectionViewDataSource y UICollectionViewDelegate
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.dragDelegate = self //seteamos a self como el dragDelegate, y añadimos el protocolo UICollectionViewDragDelegate arriba
            emojiCollectionView.dropDelegate = self //seteamos a self como el dropDelegate, y añadimos el protocolo UICollectionViewDropDelegate arriba
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //la cantidad de item en la seccion es el numero de emojis en el array emojis
        return emojis.count
    }
    
    private var font: UIFont{
        //la fuente va a estar escalada segun accesibility
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //se reusa la celda con el identificador especificado
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        //nos fijamos que cell sea del tipo EmojiCollectionViewCell (celda personalizada que creamos)
        if let emojiCell = cell as? EmojiCollectionViewCell{
            //seteamos el texto del label como un NSAttributedString al cual le pasamos como string el emoji que esta en la posicion pasada por indexPath.item a el array emojis, en los attributos se ajusta la fuente a la variable font declarada arriba de esta funcion
            let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font: font])
            emojiCell.label.attributedText = text
        }
        return cell
    }
    
    private func dragItems(at indexPath: IndexPath)-> [UIDragItem]{
        //usamos esta funcion (creada manualmente), para seleccionar los emojis de la collection view que se van a dragear
        //nos fijamos que celda esta en el indexPath seleccionado la downcasteamos como una EmojiCollectionViewCell (todo esto si hay un celda en el indexPath seleccionado), obtenemos el attributedText de la label de esa celda. Despues creamos una constante UIDragItem al cual le pasamos como itemProvider un NSItemProvider con la constante attributedString. Se setea como localObject del dragItem la constante attributedString ya que la estamos seleccionando dentro de la app
        if let attributedString = (emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell)?.label.attributedText{
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            dragItem.localObject = attributedString
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        //este metodo proporciona los items que se van a dragear, los proporcionamos llamando a la funcion dragItems(at: indexPath) declarada justo arriba
        session.localContext = collectionView //se setea como localContext la misma collectionView para saber si se deben copiar o mover los elementos seleccionados (si se agarra y se suelta dentro de una collectionView es .move)
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        //este metodo nos permite seleccionar mas de un item para dragear, llamamos a la funcion dragItems(at: indexPath) para seleccionar los items (funcion declarada arriba de la que esta arriba)
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        //este metodos se encarga de manejar los drops de cierto tipo de clase (en este caso NSAttributedString iya que queremos los emojis que tiene la collectionView)
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        //declaramos la constante isSelf para saber si el localContext de la localDragSession es la collectionView (ver el metodo itemsForBeginning que esta dos metodos arriba para saber mas sobre localContext), despues retornamos un UICollectionViewDropProposal, en caso de que isSelf sea true (es decir que seleccionemos un emoji para moverlo dentro de la collectionView) la operacion es .move, sino es .copy, el intent inserta los items en el indexPath especificado
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        //este metodo lo utilizamos para soltar los emojis, declaramos la constante destinationIndexPath igual al destinationIndexPath del coordinator (se encarga de coordinar las acciones relacionadas a drop), en caso de que sea nil se declara un IndexPath. Despues hacemos un for loop con los items del coordinator, se declara la constante sourceIndexPath igual al indexPath del item seleccionado (en caso de que haya una, significa que se esta moviendo un emoji dentro de la collectionView (localDrag)), se declara la constante attributedString igual al localObject del dragItem del item seleccioando y se la downcastea como NSAttributedString (ver mas en la funcion dragItems cuatro metodos arriba para saber mas sobre localObject). Despues se llama a collectionView.performBacthUpdates donde eliminamos el emoji del array emojis y el item de la collectionView pasando el sourceIndexPath y los insertamos pasando el destinationIndexPath. Fuera del metodo performBatchUpdates le decimos al coordinator que haga el drop.
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items{
            if let sourceIndexPath = item.sourceIndexPath{
                //localDrag, se mueve un emoji dentro de la collectionView
                if let attributedString = item.dragItem.localObject as? NSAttributedString{
                    collectionView.performBatchUpdates({
                        //todos los cambios en una collectionView y el archivo en que esa collectionView se basa deben hacerse dentro de este metodo (ejecuta todas las instrucciones a la vez)
                        emojis.remove(at: sourceIndexPath.item)
                        emojis.insert(attributedString.string, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else{
                //drag de fuera de la collectionView hacia dentro de esta
                //se crea la constante placeholderContext en la cual llamamos al coordinator y le decimos que suelte el dargItem del item en un UICollectionViewPlaceholder al cual le pasamos como insertionIndexPath el destinationIndexPath declarado sl principio de esta funcion y como reuseIdentifier le pasamos el identificador de la celda placeholder creada en el MainStoryboard
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                //se llama al metodo loadObject del itemProvider del dragItem del item que retorna el archivo de forma asincronica
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    //este colusure no se ejecuta el el hilo principal, por eso llamamos a DispatchQueue.main.async, ya que vamos a añadir una celda con una label y eso es un cambio en la UI (cambios en la UI se hacen en el hilo principal (main)), declaramos la constante attributedString y downcasteamos provider (la data recivida) como un NSAttributedString, llamamos al metodo commitInsertion de la constante placeholderContext, al metodo commitInsertion le pasamos el insertionIndexPath del placeholderContext(ver mas arriba) como indexPath y dentro el codigo que cambia la UI, en acos de que haya habido un error al solicitar el archivo se le dice al placeholderContext que borre el placeholder (placeholderContext.deletePlaceholder())
                    DispatchQueue.main.async {
                        if let attributedString = provider as? NSAttributedString {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
                            })
                        } else{
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        //esta funcion se encarga de manejar los drops de cierto tipo de clase (en este caso NSURL y UIImage), aca solo queremos la imagen de fondo y el url de esa imagen
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self) //solo carga NSURL y UIImage
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        //se copia lo que se suelta (drop) desde fuera de la aplicacion
        return UIDropProposal(operation: .copy)
    }
    
    var imageFetcher: ImageFetcher! //Declaramos una variable del tipo ImageFetcher para recibir las imagenes y las URL (ver archivo Utilities)
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        //cuando se suelta el dedo despues de arrastrar algo se ejecuta esta funcion, aca se le dice al drag and drop system que cargue los archivos de las clases que queremos
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage = (url, image)
            }
        }
        
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            //nos fijamos si el primer elemento de nsurls es una URL
            if let url = nsurls.first as? URL{
                self.imageFetcher.fetch(url)
            }
            
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            //nos fijamos si el primer elemento de images es un UIImage
            if let image = images.first as? UIImage{
                self.imageFetcher.backup = image
            }
        }
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
