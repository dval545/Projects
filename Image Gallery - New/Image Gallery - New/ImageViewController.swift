//
//  ImageViewController.swift
//  ImageGalley
//
//  Created by Admin1 on 21/12/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

//Usamos este vc para mostrar la imagen seleccionada en el collectionView en un scrollView (ver proyecto Cassini para saber mas sobre scrollView)

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    
    
    
    var bigImageView = UIImageView()
    
    var scrollViewWidth: NSLayoutConstraint!
    var scrollViewHeigth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(bigImageView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeigth?.constant = scrollView.contentSize.height
        scrollViewWidth?.constant = scrollView.contentSize.width
    }
    
    var image: UIImage?{
        get{
            return bigImageView.image
        }
        set{
            bigImageView.image = newValue
            bigImageView.sizeToFit()
            let size = newValue?.size ?? CGSize.zero
            scrollView?.contentSize = size
            scrollViewWidth?.constant = size.width
            scrollViewHeigth?.constant = size.height
            if let view = self.view, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(view.bounds.size.width / size.width, view.bounds.size.height / size.height)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return bigImageView
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
