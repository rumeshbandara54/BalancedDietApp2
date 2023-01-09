//
//  NutritionHeaderUiView.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class NutritionHeaderUiView: UIView {

    private let NutritionTopView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
   imageView.image = UIImage(named: "NutritionTopImg")
        return imageView
    }()
    
    private func addGradient(){
           let gradientLayer = CAGradientLayer()
         
           gradientLayer.frame = bounds
           layer.addSublayer(gradientLayer)
       }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(NutritionTopView)
        
        
        addGradient()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NutritionTopView.frame = bounds 
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
