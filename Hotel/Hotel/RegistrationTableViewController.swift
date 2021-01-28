//
//  RegistrationTableViewController.swift
//  Hotel
//
//  Created by Admin1 on 6/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit


class RegistrationTableViewController: UITableViewController {
    
    var reservations: [Reservation] = []
    
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

    @IBAction func unwindFromAddReservation(segue: UIStoryboardSegue){
        guard let addReservationTableViewController = segue.source as?
            AddReservationTableViewController,
            let reservation = addReservationTableViewController.reservation else { return }
        reservations.append(reservation)
        tableView.reloadData()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return reservations.count
        } else {
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        cell.textLabel?.text = "\(reservations[indexPath.row].guestName) \(reservations[indexPath.row].guestLastName)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: reservations[indexPath.row].checkIn)) \(dateFormatter.string(from: reservations[indexPath.row].checkOut)) \(reservations[indexPath.row].roomChoice.name)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reservation" {
            let indexPath = tableView.indexPathForSelectedRow!
            let res = reservations[indexPath.row]
            let navController = segue.destination as!
            UINavigationController
            let addReservationController = navController.topViewController as!
            AddReservationTableViewController
            
            addReservationController.reservationFromRegistrationTable = res
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
