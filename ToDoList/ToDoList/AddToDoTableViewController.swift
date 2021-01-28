//
//  AddToDoTableViewController.swift
//  ToDoList
//
//  Created by Admin1 on 10/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

class AddToDoTableViewController: UITableViewController {
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var isCompletedButton: UIButton!
    @IBOutlet weak var remindMeTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    var isPickerHidden = true
    var todo: ToDo?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.date.addTimeInterval(24*60*60)
        updateData()
        saveButtonState()
        updateDateLabel(date: datePicker.date)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func saveButtonState(){
        let remindMeText = remindMeTextField.text ?? ""
        saveButton.isEnabled = !remindMeText.isEmpty
    }
    
    func updateDateLabel(date: Date){
        dateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        saveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        remindMeTextField.resignFirstResponder()
    }
    
    @IBAction func isCompletedButtonTapped(_ sender: UIButton) {
        isCompletedButton.isSelected = !isCompletedButton.isSelected
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateLabel(date: datePicker.date)
    }
    
    func updateData(){
        if let todo = todo{
            navigationItem.title = "To-Do"
            remindMeTextField.text = todo.title
            isCompletedButton.isSelected = todo.isComplete
            datePicker.date = todo.dueDate
            textView.text = todo.notes
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        } else if section == 2{
            return 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let expandedCell = CGFloat(200)
        let cellIndexPath = IndexPath(row: 0, section: 1)
        let notesCellIndexPath = IndexPath(row: 0, section: 2)
        
        switch indexPath {
        case cellIndexPath:
            return isPickerHidden ? normalCellHeight : expandedCell
        case notesCellIndexPath:
            return expandedCell
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let dueDateCellIndexPath = IndexPath(row: 0, section: 1)
        switch indexPath {
        case dueDateCellIndexPath:
            isPickerHidden = !isPickerHidden
            dateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let remindText = remindMeTextField.text!
        let isComplete = isCompletedButton.isSelected
        let date = datePicker.date
        let notes = textView.text
        
        todo = ToDo(title: remindText, isComplete: isComplete, dueDate: date, notes: notes)
        
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
