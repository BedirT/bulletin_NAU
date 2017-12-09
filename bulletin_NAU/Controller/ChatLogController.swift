//
//  ChatLogController.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/6/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    let cellId = "cellId"
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid, let toID = user?.id else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toID)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: {
                (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message(dictionary: dictionary)
                
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
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

        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8 , right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        self.hideKeyboardWhenTappedAround()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        containerView.addSubview(self.inputTextField)
        
        // Constraints - SendButton
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        // Constraints - InputTextField
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let inputSeperatorLine = UIView()
        inputSeperatorLine.translatesAutoresizingMaskIntoConstraints = false
        inputSeperatorLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        containerView.addSubview(inputSeperatorLine)
        
        // Constraints - inputSeperatorLine
        inputSeperatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        inputSeperatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        inputSeperatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        inputSeperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        if let mText = message.text {
            cell.bubleWidthAnchor?.constant = estimateFrameForText(text: mText).width + 32
        }
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message){
        if let profileImageURL = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageURL)
        }
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueBubbleColor
            cell.textView.textColor = UIColor.white
            cell.bubleLeftAnchor?.isActive = false
            cell.bubleRightAnchor?.isActive = true
            cell.profileImageView.isHidden = true
        } else {
            cell.bubbleView.backgroundColor = ChatMessageCell.grayBubbleColor
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubleLeftAnchor?.isActive = true
            cell.bubleRightAnchor?.isActive = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }

    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func checkEmpty(message: String) -> Bool {
        for i in message {  // FIND HOW TO IMPLEMENT MESSAGE[0] ON ITS OWN!!!
            if i == " " {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    @objc func handleSend() {
        
        if checkEmpty(message: inputTextField.text!) {
            return
        }
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
            self.inputTextField.text = nil
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromID).child(toID)
            
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId : 1])
            
            let recipientUserMessages = Database.database().reference().child("user-messages").child(toID).child(fromID)
            recipientUserMessages.updateChildValues([messageId : 1])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
