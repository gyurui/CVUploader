//
//  UploadViewController.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 13..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import UIKit
import Alamofire

class UploadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var user : User? = nil
    var documentsArray : [Document]? = nil
    var files : [CustomFile] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func pushLogoutButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushUpdateButton(_ sender: Any) {
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download(
            "http://www.biznizdirectory.co.za/sites/default/files/business_listings/additional_images/webbler_web_sa_pty_ltd_48168/robot-33.png",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
            print("Download Progress2: \(progress.fractionCompleted)")
            }).response(completionHandler: { response in
   
                print(response.temporaryURL)
                print(response.destinationURL?.path)
                
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        
        self.tabBarController?.tabBar.tintColor = UIColor.white

        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        addFilesToTableview()
    }
    
    func addFilesToTableview()
    {
        let cv = CustomFile.init(name: "trumGyorgyCv", fileType: "pdf")
        let source = CustomFile.init(name: "CVUploader", fileType: "zip")
        
        files.append(cv)
        files.append(source)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileTableViewCell
        
        cell.nameLabel.text = files[indexPath.row].name
        cell.typeLabel.text = files[indexPath.row].fileType
        
        // Configure the cell...
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
