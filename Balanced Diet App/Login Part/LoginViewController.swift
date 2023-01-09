//
//  LoginViewController.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/7/23.
//
import UIKit

class LoginViewController: UIViewController {
    
    var loginView: LoginView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        view.backgroundColor = .blue
       
        setupView()
        
    }
   
    
  
    
    /* header bar hide krnne**/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
  
    func setupView() {
        let mainView = LoginView(frame: self.view.frame)
        self.loginView = mainView
        self.loginView.loginAction = loginPressed
        self.loginView.signupAction = signupPressed
        self.view.addSubview(loginView)
        loginView.setAnchor(top: view.topAnchor, left:view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
    }
    
    
    /*adala page ekata maru krnne button eken**/
    func loginPressed() {
        let HomeController = TabBarViewControllers()
        present(HomeController, animated: true, completion: nil)
       
    }

    
    /*adala page ekata maru krnne button eken**///
    func signupPressed() {
       // print("sign up Button pressed")
        let signUpController = SignUpController()
        present(signUpController, animated: true, completion: nil)
    }

}

