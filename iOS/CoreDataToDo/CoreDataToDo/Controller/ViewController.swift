//
//  ViewController.swift
//  CoreDataToDo
//
//  Created by 陈希 on 2021/8/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    
    private var fetchedRC: NSFetchedResultsController<ToDo>!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
        let sort = NSSortDescriptor(key: #keyPath(ToDo.dateCreated), ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
            fetchedRC.delegate = self
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        
        switch type {
        case .insert:
            todoTableView.insertRows(at: [cellIndex], with: .fade)
        case .delete:
            todoTableView.deleteRows(at: [cellIndex], with: .left)
        default:
            break
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = fetchedRC.object(at: indexPath)
            context.delete(todo)
            appDelegate.saveContext()
            todoTableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let todos = fetchedRC.fetchedObjects else {
        return 0
    }
    return todos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell", for: indexPath) as! TodoTableViewCell
    
    let todo = fetchedRC.object(at: indexPath)
    cell.todoName.text = todo.todoName
    cell.todoDescription.text = todo.todoDescription
    if let data = todo.todoImage as Data? {
        cell.todoImage.image = UIImage(data: data)
    } else {
        cell.todoImage.image = UIImage(named: "no-image.png")
    }
    
    return cell
  }
}
