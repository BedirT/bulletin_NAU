//
//  ViewController.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/5/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    let cellID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutHandle))
        let iconNewMessage = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: iconNewMessage, style: .plain, target: self, action: #selector(newMessageHandle))
        
        checkIfLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: {
            (snapshot) in
            
            let userID = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userID).observe(.childAdded, with: {
                (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageID(messageId)
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    var timer : Timer?

    private func fetchMessageWithMessageID(_ messageId: String) {
        let messageReference = Database.database().reference().child("messages").child(messageId)
        messageReference.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadOfTable()
            }
        }, withCancel: nil)
    }
    
    private func attemptReloadOfTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: {  (message1, message2) -> Bool in
            return message1.timeStamp!.intValue > message2.timeStamp!.intValue
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell

        let message = messages[indexPath.row]
        
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else{
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            let user = User(dictionary)
            user.id = chatPartnerId
            self.showChatControllerForUser(user)
        }, withCancel: nil)
    }
    
    @objc func newMessageHandle(){
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfLoggedIn(){
        if(Auth.auth().currentUser?.uid == nil) {
            perform(#selector(logoutHandle), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavbarTitle()
        }
    }
    
    func fetchUserAndSetupNavbarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let current_user = User(dictionary)
                self.setupNavbarWithUser(current_user)
            }
        }, withCancel: nil)
    }
    
    func setupNavbarWithUser(_ user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleView = UIButton()
        titleView.frame = CGRect.init(x: 0,y :0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        // Constraints
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
//        nameLabel.text = "aaaaaaaaaa aaaaaaaaa"// 21 ch
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nameLabel)
        
        // Constraints
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true

        // Constraints
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func logoutHandle() {
        do {
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }

}

