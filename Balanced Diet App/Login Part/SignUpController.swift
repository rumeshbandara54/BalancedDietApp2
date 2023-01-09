//
//  SignUpController.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/8/23.
//

import UIKit

class SignUpController: UIViewController {
    
    var signUpView: SignUpView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = .blue
        setupViews()
        
    }
    func  setupViews(){
    let signUpView = SignUpView(frame: self.view.frame)
    self.signUpView = signUpView
        self.signUpView.submitAction =  submitPressed
        self.signUpView.cancelAction =  cancelPressed
    view.addSubview(signUpView)
    }
    

    /*adala page ekata maru krnne button eken**/
    func submitPressed() {
         print("submit Button ")
        
    }
    
    /*adala page ekata maru krnne button eken**/
    func cancelPressed() {
       // print("sign up Button pressed")
        let logInController = LoginViewController()
        present(logInController, animated: true, completion: nil)
    }
}

