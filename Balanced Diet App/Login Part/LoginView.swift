//
//  LoginView.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/8/23.
//

import UIKit

class LoginView: UIView {
    
    var loginAction: (() -> Void)?
    
    var signupAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  setup(){
        let stackView = createStackView(views: [emailTextField,
                                              passwordTextField,
                                              logingButton,
                                              signupButton])
        
        
        
       addSubview(backgroundImageView)
        addSubview(DownImage)
        
        addSubview(stackView)
        backgroundImageView.setAnchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        DownImage.setAnchor(width: self.frame.width - 60, height: 80)
        
        stackView.setAnchor(width: self.frame.width - 60, height: 210)
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "LoginImage")
       
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    let DownImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "DownImage")
            return image
        }()
    
    let emailTextField: UITextField = {
        let tf = UITextField(placeHolder: "Email")
        return tf
        
    }()
    
    
    let passwordTextField: UITextField = {
        let tf = UITextField(placeHolder: "Password")
      return tf
        
    }()
    
    
    let logingButton: UIButton = {
        let button = UIButton(title: "Login" ,borderColor: UIColor.greenBorderColor)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    
    let signupButton: UIButton = {
        let button = UIButton(title: "SignUP", borderColor: UIColor.redBorderColor)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    /*UI pettaen page  change wenwda kiyla check krgnn widiha**/
    @objc func handleLogin() {
        loginAction?()
    }
    
    @objc func handleSignup() {
        signupAction?()
    }
    
}
