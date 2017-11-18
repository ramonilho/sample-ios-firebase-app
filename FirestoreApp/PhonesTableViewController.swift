//
//  PhonesTableViewController.swift
//  FirestoreApp
//
//  Created by Usuário Convidado on 17/11/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import Firebase

class PhonesTableViewController: UITableViewController {
    
    var phones: [Phone] = []

    lazy var firestore: Firestore = {
        let store = Firestore.firestore()
        return store
    }()
    
    var firestoreListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firestoreListener = firestore
            .collection("phones")
            .order(by: "model", descending: true)
            .addSnapshotListener({ (snapshot: QuerySnapshot?, error: Error?) in
                
                if error == nil {
                    guard let snapshot = snapshot else { return }
                    
                    self.phones.removeAll()
                    
                    for document in snapshot.documents {
                        let data = document.data()
                        
                        let model = data["model"] as! String
                        let manufacturer = data["manufacturer"] as! String
                        let price = data["price"] as! Double
                        let year = data["year"] as! Int
                        
                        let id = document.documentID
                        
                        let phone = Phone(id: id, model: model, manufacturer: manufacturer, price: price, year: year)
                        self.phones.append(phone)
                    }
                    
                    self.tableView.reloadData()
                }
            })
        
    }
    
    @IBAction func addPhone(_ sender: Any) {
        self.performSegue(withIdentifier: "addPhone", sender: self)
    }
    
    // MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let phone = phones[indexPath.row]
        cell.textLabel?.text = phone.model
        cell.detailTextLabel?.text = "U$ \(phone.price)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let phone = phones[indexPath.row]
            firestore.collection("phones").document(phone.id).delete()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phone = phones[indexPath.row]
        
        performSegue(withIdentifier: "editPhone", sender: phone)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let phone = sender as? Phone {
            let dvc = segue.destination as? PhoneViewController
            dvc?.phone = phone
        }
    }
    
}
