//
//  QuestionNumberCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 14.12.22.
//

import UIKit

class QuestionNumberHeader: UIView {
    

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
        
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bmw")
        return imageView
    }()
    
    //designated init - назначенный инициализатор - у каждого view, cell  он свой
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    private func setupViews() {

        self.addSubview(headerLabel)
        self.backgroundColor = .darkGray
        headerLabel.addSubview(logoImageView)
    }
    
    private func setupConstraints() {
        
        headerLabel.snp.makeConstraints{make in
            make.top.bottom.left.right.equalToSuperview().inset(30)
            }
        logoImageView.snp.makeConstraints{make in
            make.right.equalTo(headerLabel.snp.right).inset(5)
            make.top.bottom.equalTo(headerLabel)
            make.width.height.equalTo(90)
        }
        
    }
    
    //MARK: - Public
    //функция configure которая принимает нашу модель Question из QuestionResponse
    func configure(currentQuestion: Int, numberOfQuestions: Int) {
        headerLabel.text = "\(currentQuestion) / \(numberOfQuestions)"
        
    }
    
}





