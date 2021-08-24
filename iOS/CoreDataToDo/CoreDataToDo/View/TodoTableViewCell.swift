//
//  TodoTableViewCell.swift
//  CoreDataToDo
//
//  Created by 陈希 on 2021/8/24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoImage: UIImageView!
    
    @IBOutlet weak var todoName: UILabel!
    
    @IBOutlet weak var todoDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
