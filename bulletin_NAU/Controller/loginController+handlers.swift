//
//  loginController+handlers.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/6/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit
import Firebase
import Photos

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).jpg")
            
            if let profileImage = self.profilePicture.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
//            if let uploadData = UIImagePNGRepresentation(self.profilePicture.image!) { // File Compression added
                storageRef.putData(uploadData, metadata: nil, completion: {
                    (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImgURL = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImgURL]
                        self.registerUserIntoDBwithUID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    private func registerUserIntoDBwithUID(uid: String, values: [String: AnyObject]){
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            print("Saved succesfully!")
            let user = User(values)
            self.messagesController?.setupNavbarWithUser(user)
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    @objc func handleSelectingProfileImageView() {
        let picker = UIImagePickerController()
        print("HERE2")
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
            case .authorized: print("Access is granted by user")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({
                    (newStatus) in
                    print("status is \(newStatus)")
                
                    if newStatus == PHAuthorizationStatus.authorized {
                        // do stuff here */
                        print("success")
                    }
                })
            case .restricted:
                print("User do not have access to photo album.")
            case .denied:
                print("User has denied the permission.")
        }
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        var selectedImageFromPicker : UIImage?

        checkPermission()
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
//            selectedImageFromPicker = editedImage
            profilePicture.image = editedImage
        }

        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
//            selectedImageFromPicker = originalImage
            profilePicture.image = originalImage
        }
//        if let selectedImage = selectedImageFromPicker {
//            profilePicture.image = selectedImage
//        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("CANCEL")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldViewHeightAnchor?.isActive = false
        nameTextFieldViewHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldViewHeightAnchor?.isActive = true
        
        nameSeperatorHeightAnchor?.isActive = false
        nameSeperatorHeightAnchor = nameSeperator.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1)
        nameSeperatorHeightAnchor?.isActive = true
        
        emailTextFieldViewHeightAnchor?.isActive = false
        emailTextFieldViewHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldViewHeightAnchor?.isActive = true
        
        passwordTextFieldViewHeightAnchor?.isActive = false
        passwordTextFieldViewHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldViewHeightAnchor?.isActive = true
    }
    
}
