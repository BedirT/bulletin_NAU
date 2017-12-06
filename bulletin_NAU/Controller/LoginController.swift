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
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRegisterLogin () {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        }
        else {
            handleRegister()
        }
    }
    
    func handleLogin () {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            (user , error) in
            
            
            if error != nil {
                print(error!)
                return
            }
            print("IN")
            
            self.dismiss(animated: true, completion: nil)
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
    
    lazy var profilePicture : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "nau_seal")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        print("HERE1")
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectingProfileImageView)))
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
         
        nameTextFieldViewHeightAnchor?.isActive = false
        nameTextFieldViewHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldViewHeightAnchor?.isActive = true
        
        emailTextFieldViewHeightAnchor?.isActive = false
        emailTextFieldViewHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldViewHeightAnchor?.isActive = true
        
        passwordTextFieldViewHeightAnchor?.isActive = false
        passwordTextFieldViewHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldViewHeightAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r:61, g:91, b:151)
        
        // Login-Register segment added
        view.addSubview(loginRegisterSegmentedControl)
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
        setupLoginRegisterView()
        
    }
    
    func setupLoginRegisterView(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupProfilePictureView(){
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -15).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldViewHeightAnchor: NSLayoutConstraint?
    var emailTextFieldViewHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldViewHeightAnchor: NSLayoutConstraint?
    
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
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        /// - Constraints of TextFields - \\\
        // Name:
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldViewHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldViewHeightAnchor?.isActive = true
        
        // Name Seperator
        nameSeperator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Email:
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldViewHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldViewHeightAnchor?.isActive = true

        // Email Seperator
        emailSeperator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Password:
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldViewHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldViewHeightAnchor?.isActive = true
        
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
