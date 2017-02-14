//
//  ViewController.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 12..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var user : User? = nil
    var documentsArray : [Document]? = []
    
    @IBAction func pushLogin(_ sender: UIButton) {
        //sender.isEnabled = false
        loginButton.isEnabled = false
        if ( isEmailValid() && isPasswordValid())
        {
            SwiftSpinner.show("Bejelentkezés..")
            loginProcess{
                 SwiftSpinner.hide()
                 self.performSegue(withIdentifier: "showUploaderController", sender: self)
            }
        }
        else
        {
            showAlertMessage(message: "Email cím vagy jelszó nem megfelelő formátumú")
            loginButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        loginButton.layer.cornerRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarController : UITabBarController = segue.destination as? UITabBarController
        {
            let navigationVC = tabBarController.viewControllers?[0] as! UINavigationController
            let destinationVC = navigationVC.childViewControllers[0] as! UploadViewController
            destinationVC.user = user
            destinationVC.documentsArray = documentsArray
        }
    }
    
    func isEmailValid() -> Bool {
        if let text : String = emailTextField.text
        {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: text)
        }
        return false
    }
    
    func isPasswordValid() -> Bool
    {
        if let text : String = passwordTextField.text
        {
            if text.characters.count > 8
            {
                return true
            }
        }
        return false
    }
    
    func showAlertMessage(message: String)
    {
        let alert = UIAlertController.init(title: "Hopsz", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loginProcess(completed: @escaping () -> ()) {
        let parameters : Parameters = [
            "email": emailTextField.text as Any,
            "pswd": passwordTextField.text as Any
        ]
//        let parameters : Parameters = [
//            "email":"gyuri.trum@gmail.com",
//            "pswd":"PassForBigFishChallange"
//        ]
        let httpHeader : HTTPHeaders = [
            "content-Typer":"application/json"
        ]

        Alamofire.request(Constants.USER_ACCOUNT_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeader).responseJSON(completionHandler: {
            [weak self]
            response in
            let result = response.result
            self?.loginButton.isEnabled = true
            if let statusCode : Int = response.response?.statusCode
            {
                switch(statusCode)
                {
                case 200:
                    if let dict = result.value as? Dictionary<String,AnyObject> {
                        print(dict)
                        
                        self?.user = User.init(uuid: dict["uuid"] as! String, email: dict["email"] as! String, created: dict["created"] as! Int)
                        
                        completed()
                    }
                    break
                case 400:
                    self?.showAlertMessage(message: "Json, email vagy jelszó nem valid")
                    break
                case 401:
                    self?.showAlertMessage(message: "Rossz jelszo")
                    break
                case 406:
                    self?.showAlertMessage(message: "Email cím már használva van egy másik, lezárt folyamatnál")
                    break
                default:
                    self?.showAlertMessage(message: "Hiba a bejelentkezes kozben")

                }
            }
        })
    }
    

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



