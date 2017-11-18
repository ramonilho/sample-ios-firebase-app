//
//  PhoneViewController.swift
//  FirestoreApp
//
//  Created by Usuário Convidado on 17/11/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import Firebase

class PhoneViewController: UIViewController {
    
    @IBOutlet weak var tfModel: UITextField!
    @IBOutlet weak var tfManufacturer: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfYear: UITextField!
    
    var phone: Phone?
    
    lazy var firestore: Firestore = {
        let store = Firestore.firestore()
        return store
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if phone != nil {
            tfModel.text = phone?.model
            tfManufacturer.text = phone?.manufacturer
            tfPrice.text = "\(phone?.price ?? 0)"
            tfYear.text = "\(phone?.year ?? 2017)"
        }
    }
    
    @IBAction func save(_ sender: Any) {
        var phoneDict: [String: Any] = [:]
        phoneDict["model"] = tfModel.text!
        phoneDict["manufacturer"] = tfManufacturer.text!
        phoneDict["price"] = Double(tfPrice.text!)!
        phoneDict["year"] = Int(tfYear.text!)!
        
        if let phone = phone {
            firestore.collection("phones").document(phone.id).setData(phoneDict, completion: { (error) in
                self.navigationController!.popViewController(animated: true)
            })
        } else {
            firestore.collection("phones").addDocument(data: phoneDict) { (error) in
                self.navigationController!.popViewController(animated: true)
            }
        }
        
    }

}
