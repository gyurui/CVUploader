//
//  UploadViewController.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 13..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class UploadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var user : User? = nil
    var documentsArray : [Document]? = nil
    var files : [CustomFile] = []
    
    @IBOutlet weak var uploadSourceButton: UIButton!
    
    @IBOutlet weak var uploadFilesButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func pushLogoutButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushDownloadSourceCode(_ sender: UIButton) {
        sender.isEnabled = false
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        SwiftSpinner.show(progress: 0, title: "Letöltés folyamatban ...")

        Alamofire.download(
            "https://github.com/gyurui/CVUploader/archive/master.zip",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                print("Download Progress2: \(progress.fractionCompleted)")
                //self.progressView.progress = Float(progress.fractionCompleted)
                SwiftSpinner.show(progress: progress.fractionCompleted, title: "Letöltés folyamatban ...")
                
            }).response(completionHandler: {
                [weak self]
                response in
                if let statusCode : Int = response.response?.statusCode
                {
                    if statusCode == 200
                    {
                        if let url = response.destinationURL
                        {
                            let sourceCode = CustomFile.init(name: "CVUploader-master", fileType: "zip", url: url,serverType: "app source")
                            self?.files.append(sourceCode)
                            self?.tableView.reloadData()
                            SwiftSpinner.hide()

                        }
                    }
                    else{
                        sender.isEnabled = false
                        SwiftSpinner.hide()
                    }
                }
                else{
                    sender.isEnabled = true
                    SwiftSpinner.hide()
                }
            })

    }
    
    @IBAction func pushUploadedDocumentsButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showDocs", sender: self)
    }
    
    @IBAction func pushUpdateButton(_ sender: Any) {
        
        SwiftSpinner.show("Feltöltés...")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
            for file in self.files
            {
                multipartFormData.append(file.url, withName: file.serverTypeName)
            }
        },
            to: Constants.DOC_URL,
            encodingCompletion: {
                [weak self]
                encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        SwiftSpinner.hide()
                        self?.performSegue(withIdentifier: "showDocs", sender: self)
                }
                case .failure(let encodingError):
                    print(encodingError)
                    SwiftSpinner.hide()
                }
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
        uploadFilesButton.layer.cornerRadius = 10
        uploadSourceButton.layer.cornerRadius = 10
        logoutButton.layer.cornerRadius = 10
    }
    
    func addFilesToTableview()
    {

        if let myCV : URL = Bundle.main.url(forResource: "trumGyorgyCv", withExtension: "pdf")
        {
            let cv = CustomFile.init(name: "trumGyorgyCv", fileType: "pdf",url: myCV, serverType: "cv")
            files.append(cv)
        }
        
        if let myImageURL : URL = Bundle.main.url(forResource: "gyuri", withExtension: "jpg")
        {
            let myImage = CustomFile.init(name: "gyuri", fileType: "jpg", url: myImageURL, serverType: "image")
            files.append(myImage)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileTableViewCell
        
        cell.nameLabel.text = files[indexPath.row].name
        cell.typeLabel.text = files[indexPath.row].fileType
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
