//
//  BMWImageCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 20.12.22.
//

import UIKit

class BMWImageCell: UITableViewCell {
  
    static var reuseID = "BMWImageCell"
    
    private let bmwImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "bmw x")
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //напрямую инициализатор не вызывается т.к. спрятан внутри dequeueReusableCell из QuizGameVC в let cell = ...
        // и он вызывает этот инициализатор, при этом создает очередь и складывает ячейки и их переиспользует
        setupViews()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    private func setupViews() {
        contentView.addSubview(bmwImageView)
      
    }
    
    private func setupConstraints() {
        
        bmwImageView.snp.makeConstraints{make in
            make.top.bottom.left.right.equalTo(contentView)
        }
        
        
    }
    
   
    
}

