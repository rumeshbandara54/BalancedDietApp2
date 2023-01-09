//
//  SignUpView.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/8/23.
//

import UIKit

class SignUpView: UIView {
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "signUpImage")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField(placeHolder: "Name")
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField(placeHolder: "Email")
        return tf
    }()
    
    let addressTextField: UITextField = {
        let tf = UITextField(placeHolder: "Address")
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField(placeHolder: "Password")
        return tf
    }()

    
    let submiteButton: UIButton = {
        let button = UIButton(title: "Submit", borderColor: .greenBorderColor)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(title: "Cancel", borderColor: .redBorderColor)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    var submitAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addSubview(DownImage)
    }
    
    func setupViews(){
        
        let stackView = createStackView(views: [nameTextField, emailTextField,addressTextField, passwordTextField,  submiteButton, cancelButton])
        self.addSubview(backgroundImageView)
        addSubview(stackView)
        backgroundImageView.setAnchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 200, paddingRight: 0)
        DownImage.setAnchor(width: self.frame.width - 60, height: 80)
        stackView.setAnchor(width: self.frame.width - 60, height: 310)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    
    let DownImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "DownImage")
            return image
        }()
    
    /*UI pettaen page  change wenwda kiyla check krgnn widiha**/
    @objc func handleSubmit() {
        submitAction?()
    }
    
    @objc func handleCancel() {
        cancelAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
