//
//  ChatLogController.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/6/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter message"
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.white
        setupInputComponents()
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // Constraints
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        // Constraints - SendButton
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        // Constraints - InputTextField
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let inputSeperatorLine = UIView()
        inputSeperatorLine.translatesAutoresizingMaskIntoConstraints = false
        inputSeperatorLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        containerView.addSubview(inputSeperatorLine)
        
        // Constraints - inputSeperatorLine
        inputSeperatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        inputSeperatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        inputSeperatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        inputSeperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func handleSend() {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = user!.id!
        let fromID = Auth.auth().currentUser!.uid
        let timeStamp: Int = Int(Date.timeIntervalSinceReferenceDate)
        let values = ["text": inputTextField.text!, "toId": toID, "fromId": fromID, "timeStamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values) {
            (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            let userMessageRef = Database.database().reference().child("user-messages").child(fromID)
            
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId : 1])
            
            let recipientUserMessages = Database.database().reference().child("user-messages").child(toID)
            recipientUserMessages.updateChildValues([messageId : 1])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
