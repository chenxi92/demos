//
//  CreateViewController.swift
//  CoreDataToDo
//
//  Created by 陈希 on 2021/8/24.
//

import UIKit
import CoreData

class CreateViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var todoImage: UIImageView!
    @IBOutlet weak var todoNameField: UITextField!
    @IBOutlet weak var todoDescriptionField: UITextField!
    
    private var selectedImage = UIImage(named: "no-image.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        todoNameField.delegate = self
        todoDescriptionField.delegate = self
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("save button tapped")
        if isFieldEmpty() {
            displayEmptyAlert()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = (appDelegate).persistentContainer.viewContext
            
            let todo = ToDo(context: context)
            todo.todoName = todoNameField.text!
            todo.todoDescription = todoDescriptionField.text!
            todo.dateCreated = NSDate() as Date
            todo.todoImage = selectedImage?.pngData() as Data?
            
            appDelegate.saveContext()
            
            resetField()
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func resetField() {
        todoNameField.text = ""
        todoDescriptionField.text = ""
        selectedImage = UIImage(named: "no-image.png")
    }
    
    private func isFieldEmpty() -> Bool {
        var empty = true
        switch empty {
        case todoNameField.text?.isEmpty:
            empty = true
        case todoDescriptionField.text?.isEmpty:
            empty = true
        default:
            empty = false
        }
        return empty
    }
    
    private func displayEmptyAlert() {
        let alert = UIAlertController(
          title: NSLocalizedString("Required field is empty.", comment: ""),
          message: NSLocalizedString("Please fill out all the fields.", comment: ""),
          preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(
          title: "OK",
          style: UIAlertAction.Style.default,
          handler: nil
        )
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
}


extension CreateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBAction func selectButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        setImagePicker(imagePicker: imagePicker)
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setImagePicker(imagePicker: UIImagePickerController) {
      imagePicker.delegate = self
      imagePicker.navigationBar.isTranslucent = false
      imagePicker.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 22)!
      ]
      imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get picked image from info directory
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        selectedImage = image
        
        todoImage.image = image
        
        // Take image picker off the screen
        dismiss(animated: true, completion: nil)
    }
}


extension CreateViewController: UITextFieldDelegate {
    
}
