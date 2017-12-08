//
//  UserCell.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/6/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setupNameAndProfilePicture()
            self.detailTextLabel?.text = message?.text
            if let seconds = message?.timeStamp?.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                timeLabel.text = dateFormatter.string(from: timeStampDate)
            }
        }
    }
    
    private func setupNameAndProfilePicture(){
        let chatPartnerId: String?
        
        if message?.fromID == Auth.auth().currentUser?.uid {
            chatPartnerId = message?.toID
        } else {
            chatPartnerId = message?.fromID
        }
        
        if let toID = chatPartnerId {
            let ref = Database.database().reference().child("users").child(toID)
            ref.observe(.value){
                (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageURL = dictionary["profileImageUrl"] as? String{
                        self.profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageURL)
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect.init(x: 64,y :textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect.init(x: 64,y :detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfilePicturePlaceHolder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        // profileImageView constraints
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        // timeLabel constraints
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
