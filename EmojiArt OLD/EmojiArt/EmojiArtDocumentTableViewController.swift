//
//  EmojiArtDocumentTableViewController.swift
//  EmojiArt
//
//  Created by Admin1 on 8/12/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

class EmojiArtDocumentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    @IBAction func newEmojiArt(_ sender: UIBarButtonItem) {
        //usamos esta accion para añadir mas elementos al array emojiArtDocuments (que despues se muestran en la tabla), y despues llamamos a reloadData() para que muestre las nuevas filas
        emojiArtDocuments.append("Untitled")
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //en este metodo añadimos la funcion para poder esconder la tabla (tableView), seteamos el preferredDisplayMode del splitViewController? (si hay algun splitViewController) como .primaryOverlay (se cubre el viewController primario (el master)), (option sobre los metodos para saber mas)
        if splitViewController?.preferredDisplayMode != .primaryOverlay{
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    
    var emojiArtDocuments = ["One", "Two", "Three"] //declaramos un array de strings que despues se va a mostrar en la tabla

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //retorna la cantidad de secciones de la tabla
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //retorna el numero de filas de cada seccion, en este caso queremos una fila por cada elemento del array emojiArtDocuments
        return emojiArtDocuments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //se reutilizan las celdas pasando el identificador correspondiente
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        // Configure the cell...
        //se configura la celda, texto, subtitulo etc
        cell.textLabel?.text = emojiArtDocuments[indexPath.row] //usamos la fila para acceder al elemento del array
        

        return cell
    }
    

    /* este metodo se lo descomenta si se busca que cierto item no sea editable
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //eliminamos un elemento del array, pasando el indexPath.row (la fila seleccionada), despues se elimina la fila
            emojiArtDocuments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
