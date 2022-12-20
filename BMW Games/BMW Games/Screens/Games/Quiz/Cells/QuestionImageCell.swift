//
//  QuestionImageCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 14.12.22.
//

import UIKit
import SDWebImage

class QuestionImageCell: UITableViewCell {
    
    static var reuseID = "QuestionImageCell"
    
    private lazy var questionImageView: UIImageView = {
        
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        contentView.addSubview(questionImageView)
        contentView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        
        questionImageView.snp.makeConstraints{make in
            make.top.bottom.left.right.equalTo(contentView)
        }
        
    }
    
    //MARK: - Public
    //функция configure которая принимает нашу модель Question из QuestionResponse
    func configure(_ model: Question?) {
       // questionImageView.image = .init(named: model?.image ?? "") // ?? ""
        let url = URL.init(string: model?.image ?? "")
        questionImageView.sd_setImage(with: url)
        
    }
    
}


