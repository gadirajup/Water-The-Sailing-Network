//
//  SignUpController.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/12/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    // MARK:- Properties
    
    var imageSelected = false
    
    // MARK:- UI Elements
    
    let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.constrainHeight(constant: 48)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.constrainHeight(constant: 48)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.constrainHeight(constant: 48)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.constrainHeight(constant: 48)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.constrainHeight(constant: 48)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 153/255, blue: 237/255, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .white
        
        // Add Photo Button
        
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        addPhotoButton.constrainHeight(constant: 140)
        addPhotoButton.constrainWidth(constant: 140)
        addPhotoButton.centerXInSuperview()
        
        // Add Sign Up Form
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, userNameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: addPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 32, bottom: 0, right: 32))
        
        view.addSubview(loginButton)
        loginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
    }
    
    // MARK:- Handlers
    
    @objc fileprivate func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func formValidation() {
        guard
            emailTextField.hasText,
            passwordTextField.hasText,
            fullNameTextField.hasText,
            userNameTextField.hasText,
            imageSelected == true
        else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    @objc fileprivate func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        
        // Create User
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // Handle any User Erro
            if let error = error {
                print("Failed to Create User: ", error.localizedDescription)
                return
            }
            
            print("Successfully Created User")
            
            // Get profile image as data
            guard let profileImage = self.addPhotoButton.imageView?.image else { return }
            guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
            
            // Save Profile Image Data in Storage
            let fileName = UUID().uuidString
            Storage.storage().reference(withPath: fileName).putData(imageData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Failed to upload image to firebase storage", error.localizedDescription)
                    return
                }
                
                // Get location of saved image data as URL
                Storage.storage().reference(withPath: fileName).downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("Failed to download url of image", error.localizedDescription)
                        return
                    }
                    
                    // Make sure url exists
                    guard let url = url else { return }
                    
                    // get string version of url to be saved
                    let profileImageUrl = url.absoluteString
                    
                    // All the data to be stored in database with saved image url
                    let dictionaryValues = [
                        "name": fullName,
                        "username": userName,
                        "profileImageUrl": profileImageUrl
                    ]
                    
                    // save user data with document id as user id
                    guard let uid = user?.user.uid else { return }
                    Firestore.firestore().collection("users").document(uid).setData(dictionaryValues, completion: { (error) in
                        if let error = error {
                            print("Failed to upload user information", error.localizedDescription)
                        }
                        
                        print("Successfully saved to users collections")
                    })
                })
            })
            
        }
    }
    
    @objc fileprivate func handleSelectProfilePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK :- Image Picker
extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage]  as? UIImage else {
            imageSelected = false
            return
        }
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 1
        addPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        imageSelected = true
        
        formValidation()
        dismiss(animated: true, completion: nil)
    }
}
