//
//  DocumentsViewController.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 14..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class DocumentsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var documents : [Document] = []

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var deletButton: UIButton!
    
    @IBAction func pushDeletAllButton(_ sender: Any) {
        deleteProcess ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        downloadDocs()
        {
            self.tableView.reloadData()
        }
        deletButton.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! DocumentTableViewCell
        
        cell.nameLabel.text = documents[indexPath.row].name
        cell.sizeLabel.text = "Size: \(documents[indexPath.row].size)"
        cell.createLabel.text = "Created: \(documents[indexPath.row].created)"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func downloadDocs(completed : @escaping () -> ())
    {
        Alamofire.request(Constants.DOC_URL).responseJSON(completionHandler: {
            [weak self]
            response in
            let result = response.result
            if let docArray = result.value as? Array<Any>
            {
                for doc in docArray {
                    if let dict = doc as? Dictionary<String,AnyObject> {
                        let newDocument = Document.init(uuid: dict["uuid"] as! String, size: dict["size"] as! Int, name: dict["name"] as! String, created: dict["created"] as! Int)
                        self?.documents.append(newDocument)
                    }
                }
                completed()
            }
        })
    }
    
    func deleteProcess()
    {
        SwiftSpinner.show("Törlés folyamatban ...")
        var parameters : Array? = []
    
            for doc in documents {
                var dict : Parameters = [:]
                dict["uuid"] = doc.uuid
                parameters?.append(dict)
            }
        
        
        if let url = NSURL(string:Constants.DOC_URL){
            var request = URLRequest(url: url as URL)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "DELETE"
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters!, options: [])
            
            Alamofire.request(request)
                .responseJSON {
                    [weak self]
                    response in
                    SwiftSpinner.hide()
                    if response.response?.statusCode == 200
                    {
                        self?.documents.removeAll()
                        self?.tableView.reloadData()
                    }
            }
        


        }
    }


}
