//
//  ViewController.swift
//  loginForm
//
//  Created by soc-lap-18 on 5/25/18.
//  Copyright © 2018 soc-lap-18. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureButton()
    }
    func configureTextFields() {
        emailTextField.leftViewMode = .always
        let emailImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        emailImageView.image = #imageLiteral(resourceName: "mail")
        emailImageView.contentMode = .scaleAspectFit
        emailTextField.leftView = emailImageView
        
        passwordTextField.leftViewMode = .always
        let passwordImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        passwordImageView.image = #imageLiteral(resourceName: "password")
        passwordImageView.contentMode = .scaleAspectFit
        passwordTextField.leftView = passwordImageView
    }
    func configureButton(){
        loginButton.layer.borderColor = UIColor(red: 0/255, green: 143/255, blue: 125/255, alpha: 1.0).cgColor
        loginButton.layer.borderWidth = 3
    }
    func validateFields() -> String? {
        guard let email = emailTextField.text, email != "" else {
            return "Please enter your email"
        }
        guard isValidEmail(testStr: email) else {
            return "Please enter valid email"
        }
        guard let passwd = passwordTextField.text, passwd != "" else {
            return "Please enter your password"
        }
        guard passwd.count > 7 else {
            return "Please enter password more than or equal to 8 characters"
        }
        return nil
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }


    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let error = validateFields()
        var msg = ""
        if error != nil {
            msg = error!
        } else {
            msg = "Logged in successfully"
        }
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error) :
                print(error)
            case .cancelled:
                print("user cancelled the facebook login")
            case .success(grantedPermissions: _, declinedPermissions: _, token: let accessToken):
                print("loggedIn")
                if AccessToken.current != nil {
                    let param =  ["fields": "email,name,first_name,last_name,picture.width(720).height(720)"]
                    GraphRequest(graphPath: "me", parameters: param, accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion).start({ (connection, result) in
                        switch result {
                        case .success(let response):
                            let user = UserInfo(data: response.dictionaryValue!)
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeViewController {
                                vc.user = user
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        case .failed(let error):
                            print(error)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "550724366660-ck2g6rt78pgiscq25fhj2j02vo8rinav.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userInfo = UserInfo(data: ["":""])
            userInfo.email = user.profile.email
            userInfo.name = user.profile.name
            userInfo.picture = user.profile.imageURL(withDimension: 140).description
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeViewController {
                vc.user = userInfo
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            print(error.localizedDescription)
        }
    }
}

