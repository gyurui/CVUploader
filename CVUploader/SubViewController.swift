//
//  SubViewController.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 14..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class SubViewController: UIViewController {
    
    var submitUUID = ""
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func pushSubmitButton(_ sender: Any) {
        submitButton.isEnabled = false
        SwiftSpinner.show("Lezárás...")
        Alamofire.request(Constants.SUBMIT_URL).responseJSON {
            [weak self]
            response in
            SwiftSpinner.hide()
            if let dict = response.result.value as? Dictionary<String,String> {
                if let uuid : String = dict["uuid"]
                {
                    self?.submitUUID = uuid
                    self?.areYouSureAboutThis()
                }
            }
        }
        
    }
    
    func areYouSureAboutThis()
    {
        let refreshAlert = UIAlertController(title: "Figyelem", message: "Ha egyszer lezártad a folyamatot az nem nyitható meg újra. Biztosan lezárod a folyamatot? ", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Igen", style: .default, handler: { (action: UIAlertAction!) in
            self.submitApp()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Nem", style: .cancel, handler: { (action: UIAlertAction!) in
            self.submitButton.isEnabled = true
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func submitApp()
    {
        
            let parameters : Parameters = [
                "uuid": submitUUID as Any
            ]

            let httpHeader : HTTPHeaders = [
                "content-Typer":"application/json"
            ]
            
            Alamofire.request(Constants.SUBMIT_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeader).responseJSON(completionHandler: {
                [weak self]
                response in
                if let statusCode : Int = response.response?.statusCode
                {
                    if statusCode == 200
                    {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10
    }
}
