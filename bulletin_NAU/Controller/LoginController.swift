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
    
    var messagesController: MessagesController?
    
    let mainRedColor: UIColor? = UIColor(r: 252,g: 67,b: 73)
    let mainLightBlueColor: UIColor? = UIColor(r: 215,g: 218,b: 219)
    let mainDarkBlueColor: UIColor? = UIColor(r: 44,g: 62,b: 80)
    // Text Color = UIColor(r: 181,g: 186,b: 191)

    let inputContainerView: UIView = {
        let view = UIView()
        
        // BG
        view.backgroundColor = UIColor(r: 215,g: 218,b: 219)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Round corners
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 252,g: 67,b: 73)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "Avenir", size: 16)
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
            self.messagesController?.fetchUserAndSetupNavbarTitle()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    let nameTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Name"
        txtField.textColor = UIColor(r: 181,g: 186,b: 191)
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let nameSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 181,g: 186,b: 191)
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Email"
        txtField.textColor = UIColor(r: 181,g: 186,b: 191)
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let emailSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 181,g: 186,b: 191)
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Password"
        txtField.textColor = UIColor(r: 181,g: 186,b: 191)
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.isSecureTextEntry = true
        return txtField
    }()
    
    lazy var profilePicture : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "ProfilePHolder")
        img.layer.cornerRadius = 75
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var profilePictureChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.font =  UIFont(name: "Avenir Light", size: 12)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 20.0, 0.0)
        button.backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 0.7)
        button.addTarget(self, action: #selector(handleSelectingProfileImageView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = mainLightBlueColor
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainDarkBlueColor
        
        // Login-Register segment added
        view.addSubview(loginRegisterSegmentedControl)
        // pp field is added
        view.addSubview(profilePicture)
        // pp button added
        view.addSubview(profilePictureChangeButton)
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
        setupProfilePictureChangerButton()
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func setupLoginRegisterView(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupProfilePictureView(){
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -20).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupProfilePictureChangerButton(){
        profilePictureChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePictureChangeButton.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -20).isActive = true
        profilePictureChangeButton.widthAnchor.constraint(equalTo: profilePicture.widthAnchor).isActive = true
        profilePictureChangeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldViewHeightAnchor: NSLayoutConstraint?
    var emailTextFieldViewHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldViewHeightAnchor: NSLayoutConstraint?
    var nameSeperatorHeightAnchor: NSLayoutConstraint?
    
    // Adding constrains for inputContainerView
    // x, y, height, width
    func setupInputsContainerView(){
        // X - Center
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Y - Center
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
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
        nameSeperator.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        nameSeperator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -20).isActive = true
        nameSeperatorHeightAnchor = nameSeperator.heightAnchor.constraint(equalToConstant: 1)
        nameSeperatorHeightAnchor?.isActive = true

        // Email:
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldViewHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldViewHeightAnchor?.isActive = true

        // Email Seperator
        emailSeperator.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -20).isActive = true
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
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
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
