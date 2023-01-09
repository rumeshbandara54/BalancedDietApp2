//
//  desingTableViewCell.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class desingTableViewCell: UITableViewCell {

   static let identifier = "desingTableViewCell"
    
    
    private let collectionView: UICollectionView = {
        /*kotu wala size**/
        let layout = UICollectionViewFlowLayout()
       layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  layout)
        
     //   collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
      collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:"cell")
    return collectionView
  }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
}

extension desingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    

    
}
