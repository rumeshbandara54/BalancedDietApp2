//
//  RegisterViewController.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // Register field with input values
    
    var passwordValue = ""
    var confPasswordValue = ""
    let password = UITextField()
    let confPassword = UITextField()
    var username:UITextField!
    var email:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .systemBackground
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let userLabel = setUpLabel(UILabel())
        userLabel.text = "Username"
        
        username = setUpField(UITextField())
        username.placeholder = "Enter User Name"
        username.returnKeyType = UIReturnKeyType.next
        username.autocapitalizationType = UITextAutocapitalizationType.none
        username.keyboardType = UIKeyboardType.emailAddress
        username.tag = 1
        
        let emailLabel = setUpLabel(UILabel())
        emailLabel.text = "Email"
        
        email = setUpField(UITextField())
        email.placeholder = "rumesh@gmail.com"
        email.returnKeyType = UIReturnKeyType.next
        email.autocapitalizationType = UITextAutocapitalizationType.none
        email.keyboardType = UIKeyboardType.emailAddress
        email.tag = 2
        
        let passwordLabel = setUpLabel(UILabel())
        passwordLabel.text = "Password"
        
        password.placeholder = "********"
        password.borderStyle = .roundedRect
        password.returnKeyType = UIReturnKeyType.next
        password.textContentType = UITextContentType(rawValue: "")
        password.autocorrectionType = .no
        password.spellCheckingType = .no
        password.autocapitalizationType = .none
        password.keyboardType = .default
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = .systemGray6
        password.delegate = self
        password.tag = 3
        password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let confPasswordLabel = setUpLabel(UILabel())
        confPasswordLabel.text = "Confirm Password"
        
        confPassword.placeholder = "********"
        confPassword.borderStyle = .roundedRect
        confPassword.returnKeyType = UIReturnKeyType.next
        confPassword.textContentType = UITextContentType(rawValue: "")
        confPassword.autocorrectionType = .no
        confPassword.spellCheckingType = .no
        confPassword.autocapitalizationType = .none
        confPassword.keyboardType = .default
        confPassword.translatesAutoresizingMaskIntoConstraints = false
        confPassword.backgroundColor = .systemGray6
        confPassword.delegate = self
        confPassword.tag = 4
        confPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let registerButton = UIButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitle("REGISTER", for: .normal)
        registerButton.layer.cornerRadius = 17
        registerButton.addTarget(self, action: #selector(doRegister), for: .touchUpInside)
        
        container.addSubview(userLabel)
        container.addSubview(username)
        container.addSubview(emailLabel)
        container.addSubview(email)
        container.addSubview(passwordLabel)
        container.addSubview(password)
        container.addSubview(confPasswordLabel)
        container.addSubview(confPassword)
        container.addSubview(registerButton)
        
        view.addSubview(container)
        
        // Set constainsts for the UI elements
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            userLabel.topAnchor.constraint(equalTo: container.topAnchor),
            userLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
            username.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5),
            username.widthAnchor.constraint(equalTo: container.widthAnchor),
            username.heightAnchor.constraint(equalToConstant: 45),
            
            emailLabel.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 20),
            emailLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
            email.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            email.widthAnchor.constraint(equalTo: container.widthAnchor),
            email.heightAnchor.constraint(equalToConstant: 45),
            
            passwordLabel.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20),
            passwordLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
            password.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            password.widthAnchor.constraint(equalTo: container.widthAnchor),
            password.heightAnchor.constraint(equalToConstant: 45),
            
            confPasswordLabel.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            confPasswordLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
            confPassword.topAnchor.constraint(equalTo: confPasswordLabel.bottomAnchor, constant: 5),
            confPassword.widthAnchor.constraint(equalTo: container.widthAnchor),
            confPassword.heightAnchor.constraint(equalToConstant: 45),
            
            registerButton.topAnchor.constraint(equalTo: confPassword.bottomAnchor, constant: 30),
            registerButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            registerButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 40),
            registerButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        // Hide keyboard when tapped on background
        self.hideKeyboardWhenTappedAround()
        // Focus on input if it gets hidden by the keyboard
        self.addKeyboardObserver()
    }
    
    func setUpLabel(_ label: UILabel) -> UILabel {
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        return label;
    }
    
    func setUpField(_ field: UITextField) -> UITextField {
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .systemGray6
        field.delegate = self
        field.autocorrectionType = UITextAutocorrectionType.no
        return field;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    // Go to next Text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    // Call api with register values
    @objc func doRegister() {
        var errorMsg = ""
        if (!checkFieldValid(username)) {
            errorMsg += "Username "
        }
        if (!checkFieldValid(email)) {
            errorMsg += "Email "
        }
        if (!checkFieldValid(password)) {
            errorMsg += "Password "
        }
        if (!checkFieldValid(confPassword)) {
            errorMsg += "Confirm Password "
        }
        if (errorMsg != "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter value for " + errorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (!emailPred.evaluate(with: email.text)) {
            let alert = UIAlertController(title: "Alert", message: "Please enter a valid email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (passwordValue != confPasswordValue) {
            let alert = UIAlertController(title: "Alert", message: "Password and Confirm Password doesn't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        APICalls.registerUser(username.text!, email.text!, passwordValue){ (result) in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            
            if (result) {
                let alert = UIAlertController(title: "Alert", message: "Account created. Please login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Error occurred when creating account. Please try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Workaround to fix strong password bug in simulators
    // https://stackoverflow.com/a/52427015
    @objc func textFieldDidChange(_ textField: UITextField) {
        var passwordValue = self.passwordValue
        var passwordField = self.password
        if (textField.tag == 3) {
            passwordValue = self.passwordValue
            passwordField = self.password
        } else {
            passwordValue = self.confPasswordValue
            passwordField = self.confPassword
        }
        if textField.text!.count > 1 {
            // User did copy & paste
            if passwordValue.count == 0 { // Pasted into an empty textField
                passwordValue = String(textField.text!)
            } else { // Pasted to a non empty textField
                passwordValue += textField.text!.dropFirst(passwordValue.count)
            }
        } else {
            // User did input by keypad
            if textField.text!.count > passwordValue.count { // Added chars
                passwordValue += String(textField.text!.last!)
            } else if textField.text!.count < passwordValue.count { // Removed chars
                passwordValue = String(passwordValue.dropLast())
            }
        }
        if (textField.tag == 3) {
            self.passwordValue = passwordValue
        } else {
            self.confPasswordValue = passwordValue
        }
        passwordField.text = String(repeating: "•", count: passwordField.text!.count)
    }
    
    func checkFieldValid(_ field: UITextField) -> Bool {
        let fieldText = field.text
        if (fieldText == nil || fieldText!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            return false
        } else {
            return true
        }
    }

}
