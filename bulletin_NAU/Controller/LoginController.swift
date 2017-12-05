//
//  LoginController.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/5/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    let inputContainerView: UIView = {
        let view = UIView()
        
        // BG
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Round corners
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (user: User?, error) in

            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://bulletin-nau.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: {
                (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                print("Saved succesfully!")
            })
        })
        
    }
    
    let nameTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Name"
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let nameSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Email"
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let emailSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Password"
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.isSecureTextEntry = true
        return txtField
    }()
    
    let profilePicture : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "nau_seal")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r:61, g:91, b:151)
        
        // pp field is added
        view.addSubview(profilePicture)
        // Input textfield is added
        view.addSubview(inputContainerView)
        // Register Button added
        view.addSubview(loginRegisterButton)
        // TextFields added
        view.addSubview(nameTextField)
        view.addSubview(nameSeperator)
        view.addSubview(emailTextField)
        view.addSubview(emailSeperator)
        view.addSubview(passwordTextField)
        
        setupInputsContainerView()
        setupRegisterButtonContainerView()
        setupProfilePictureView()
        
    }
    
    func setupProfilePictureView(){
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -15).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    // Adding constrains for inputContainerView
    // x, y, height, width
    func setupInputsContainerView(){
        // X - Center
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Y - Center
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // Height
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -36).isActive = true
        // Width
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        /// - Constraints of TextFields - \\\
        // Name:
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true

        // Name Seperator
        nameSeperator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Email:
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true


        // Email Seperator
        emailSeperator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Password:
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    }
    
    // Adding constrains for loginRegisterButton
    // x, y, height, width
    func setupRegisterButtonContainerView(){
        // X - Center
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Y - Center
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        // Height
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        // Width
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}

extension UIColor {
    
    convenience init (r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
