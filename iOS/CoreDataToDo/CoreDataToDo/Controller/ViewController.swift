//
//  ViewController.swift
//  CoreDataToDo
//
//  Created by 陈希 on 2021/8/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }


}

extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell", for: indexPath) as! TodoTableViewCell
    
    cell.todoImage.image = UIImage(named: "no-image.png")
    cell.todoName.text = "ToDo Name"
    cell.todoDescription.text = "Description"
    
    return cell
  }
}
