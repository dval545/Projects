//
//  ViewController.swift
//  ImageGalley
//
//  Created by Admin1 on 21/12/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit


//El objetivo de la aplicacion es poder arrastrar imagenes de fuera de la app hacia dentro de esta, mostrar la imagen seleccionada en otro vc.

//En este vc declaramos una collectionView y seteamos a self como los delegates necesarios (para seber mas sobre collectionView ver proyecto EmojiArt)

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate{
    
    
    
    var urlsPersistence =  [URL]()
     
    var images = [UIImage]()
    var gallery: Galleries?
    var document: GalleryDocument?
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.dragDelegate = self
            collectionView.dropDelegate = self
            collectionView.dragInteractionEnabled = true
            
        }
    }
    
    
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    
    @IBAction func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed{
            sender.scale = 1.0
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        }
    }
    
    
    func addingPinchGesture(){
        for cell in collectionView.visibleCells{
            if let imageCell = cell as? CollectionViewCell{
                imageCell.addGestureRecognizer(pinchGestureRecognizer)
                imageCell.imageView.addGestureRecognizer(pinchGestureRecognizer)
            }
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem? = nil) {
        gallery = Galleries(urlOfImages: urlsPersistence)
        document?.gallery = gallery
        if document?.gallery != nil {
            document?.updateChangeCount(.done)
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        save()
        if document?.gallery != nil {
            guard let url = gallery?.urlOfImages.first else { return }
            let urlContents = try? Data(contentsOf: url)
            guard let imageData = urlContents else { return }
            let newImage = UIImage(data: imageData)
            guard let image = newImage else { return }
            let img = UIImageView()
            img.image = image
            document?.thumbnail = img.snapshot
        }
        dismiss(animated: true){
            self.document?.close()
        }
    }
    
    
    func addingImages(){
        for item in urlsPersistence{
            let urlContents = try? Data(contentsOf: item.imageURL)
            guard let imageData = urlContents else { return }
            let newImage = UIImage(data: imageData)
            guard let image = newImage else { return }
            images.append(image)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        document?.open{ success in
            if success{
                self.title = self.document?.localizedName
                self.gallery = self.document?.gallery
            }
        }
        guard let urls = gallery?.urlOfImages else { return }
        urlsPersistence = urls
        addingImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let imageCell = cell as? CollectionViewCell{
            let image = images[indexPath.item]
            imageCell.imageView.image = image
        }
        return cell
    }
    
    
    private func dragItems(with indexPath: IndexPath)-> [UIDragItem]{
        if let selectedImage = (collectionView.cellForItem(at: indexPath) as? CollectionViewCell)?.imageView.image{
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: selectedImage))
            dragItem.localObject = selectedImage
            return [dragItem]
        } else {
            return []
        }
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(with: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(with: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items{
            if let sourceIndexPath = item.sourceIndexPath{
                if let image = item.dragItem.localObject as? UIImage{
                    collectionView.performBatchUpdates({
                        images.remove(at: sourceIndexPath.item)
                        images.insert(image, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else{
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "PlaceholderCell"))
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { (provider, error) in
                    if let nsurl = provider as? NSURL{
                          if let url = nsurl as? URL{
                            self.urlsPersistence.append(url)
                            let urlContents = try? Data(contentsOf: url.imageURL)
                            DispatchQueue.main.async {
                                guard let imageData = urlContents else { return }
                                let newImage = UIImage(data: imageData)
                                placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                    if let image = newImage{
                                        self.images.insert(image, at: destinationIndexPath.item)
                                    }
                                })
                            }
                        } else{
                            placeholderContext.deletePlaceholder()
                        }
                    }
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Showing Image"{
            if let indexPath = collectionView.indexPathsForSelectedItems{
                if let index = indexPath.first?.item{
                    let image = images[index]
                    if let imageViewController = segue.destination as? ImageViewController{
                        imageViewController.image = image
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addingImages()
        addingPinchGesture()
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
