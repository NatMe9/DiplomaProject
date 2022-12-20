//
//  QuestionTextCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 5.12.22.
//

import UIKit

class QuestionTextCell: UITableViewCell {
    
    static var reuseID = "QuestionTextCell"
    
    private lazy var backgroundCellView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red:111/255, green:111/255, blue:111/255, alpha: 0.3)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 //не в одну строку
        label.lineBreakMode = .byWordWrapping //разбить по словам т.е. перенос по словам
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
        
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
        contentView.addSubview(backgroundCellView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        
        backgroundCellView.snp.makeConstraints{make in
            make.top.bottom.left.right.equalTo(contentView).inset(10)
        }
        
        titleLabel.snp.makeConstraints{make in
            make.top.bottom.left.right.equalTo(backgroundCellView).inset(30)
        }
        
    }
    
    //MARK: - Public
    //функция configure которая принимает нашу модель Question из QuestionResponse
    func configure(_ model: Question?) {
        titleLabel.text = model?.text ?? "" // ?? "" - иначе пустая строка
        
    }
    
}

