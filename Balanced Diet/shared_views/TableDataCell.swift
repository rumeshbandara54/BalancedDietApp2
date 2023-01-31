//
//  TableCollectionViewCell.swift
//  Balanced Diet
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

// Custom cell to display table cells
class TableDataCell: UICollectionViewCell {
    
    let header = UILabel()
    
    var data: FoodCellDTO? {
        didSet {
            header.text = data!.header
            
            var curY = header.frame.height
            for item in data!.data {
                let dataBox = UILabel(frame: CGRect(x: 0, y: curY, width: contentView.bounds.width, height: 25))
                curY += dataBox.frame.height
                dataBox.text = item
                dataBox.textAlignment = data!.allignment
                dataBox.font = .systemFont(ofSize: 16)
                dataBox.layer.borderColor = UIColor.systemGray3.cgColor
                dataBox.layer.borderWidth = 1
                dataBox.textColor = .label
                contentView.addSubview(dataBox)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        header.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: 25)
        header.textAlignment = .center
        header.font = .boldSystemFont(ofSize: 18)
        header.layer.borderColor = UIColor.systemGray4.cgColor
        header.layer.borderWidth = 1
        header.textColor = .label
        
        contentView.addSubview(header)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
