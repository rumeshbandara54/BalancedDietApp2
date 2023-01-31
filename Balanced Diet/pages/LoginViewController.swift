//
//  LoginViewController.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var passwordValue = ""
    let password = UITextField()
    var username:UITextField!

    // login view. setting up
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .systemBackground
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let userLabel = UILabel()
        userLabel.textAlignment = .left
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.font = .systemFont(ofSize: 14)
        userLabel.text = "Username"
        
        username = UITextField()
        username.placeholder = "Enter UserName"
        username.borderStyle = .roundedRect
        username.returnKeyType = UIReturnKeyType.next
        username.autocapitalizationType = UITextAutocapitalizationType.none
        username.autocorrectionType = UITextAutocorrectionType.no
        username.keyboardType = UIKeyboardType.default
        username.translatesAutoresizingMaskIntoConstraints = false
        username.backgroundColor = .systemGray6
        username.delegate = self
        username.tag = 1
        
        let passwordLabel = UILabel()
        passwordLabel.textAlignment = .left
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.font = .systemFont(ofSize: 14)
        passwordLabel.text = "Password"
        
        password.placeholder = "********"
        password.borderStyle = .roundedRect
        password.returnKeyType = UIReturnKeyType.done
        password.textContentType = UITextContentType(rawValue: "")
        password.autocorrectionType = .no
        password.spellCheckingType = .no
        password.autocapitalizationType = .none
        password.keyboardType = .default
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = .systemGray6
        password.delegate = self
        password.tag = 2
        password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.layer.cornerRadius = 17
        loginButton.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
        
        let registerButton = UIButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.setTitle("create an account", for: .normal)
        registerButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        
        container.addSubview(userLabel)
        container.addSubview(username)
        container.addSubview(passwordLabel)
        container.addSubview(password)
        container.addSubview(loginButton)
        container.addSubview(registerButton)
        
        view.addSubview(container)
        
        // set constraint and activate them
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            userLabel.topAnchor.constraint(equalTo: container.topAnchor),
            userLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
            username.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5),
            username.widthAnchor.constraint(equalTo: container.widthAnchor),
            
            userLabel.topAnchor.constraint(equalTo: container.topAnchor),
            userLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
            username.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5),
            username.widthAnchor.constraint(equalTo: container.widthAnchor),
            username.heightAnchor.constraint(equalToConstant: 45),
            
            passwordLabel.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 20),
            passwordLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
            password.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            password.widthAnchor.constraint(equalTo: container.widthAnchor),
            password.heightAnchor.constraint(equalToConstant: 45),
            
            loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            loginButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
            registerButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        self.hideKeyboardWhenTappedAround()
        self.addKeyboardObserver()
    }
    
    // Call the login api with given values
    @objc func doLogin() {
        var errorMsg = ""
        if (!checkFieldValid(username)) {
            errorMsg += "Username "
        }
        if (!checkFieldValid(password)) {
            errorMsg += "Password "
        }
        if (errorMsg != "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter value for " + errorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        APICalls.loginUser(username.text!, passwordValue){ (result) in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            
            if (result) {
                UserDefaults.standard.set(self.username.text!, forKey: "USERNAME")
                let alert = UIAlertController(title: "Alert", message: "Logged in Successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Username or Password is invalid. Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // method to hide keyboard
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    // Go to next Text field when next is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    // Go to register
    @objc func goToRegister() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    // Hide characters and add dots instead. This approach is used to mitage a secure input bug in the simulator
    // https://stackoverflow.com/a/52427015
    @objc func textFieldDidChange(_ textField: UITextField) {
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
        self.password.text = String(repeating: "•", count: self.password.text!.count)
    }
    
    // check wheather if a text field is valid
    func checkFieldValid(_ field: UITextField) -> Bool {
        let fieldText = field.text
        if (fieldText == nil || fieldText!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            return false
        } else {
            return true
        }
    }

}
