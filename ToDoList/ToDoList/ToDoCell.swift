//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Admin1 on 12/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate: class{
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    
    
    var delegate: ToDoCellDelegate?
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
