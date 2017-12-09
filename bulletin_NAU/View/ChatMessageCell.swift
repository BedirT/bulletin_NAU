//
//  ChatMessageCell.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/8/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "sample text"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        return tv
    }()
    
    static let blueBubbleColor = UIColor(r:0, g:137, b:249)
    static let grayBubbleColor = UIColor(r:240, g:240, b:240)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueBubbleColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfilePicturePlaceHolder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var bubleWidthAnchor: NSLayoutConstraint?
    var bubleRightAnchor: NSLayoutConstraint?
    var bubleLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        // constraints
        
        // x,y,w,h
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // x,y,w,h
        bubleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        bubleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // x,y,w,h
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        self.isUserInteractionEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
