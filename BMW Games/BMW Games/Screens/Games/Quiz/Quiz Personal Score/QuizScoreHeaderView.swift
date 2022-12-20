//
//  QuizScoreHeaderView.swift
//  BMW Games
//
//  Created by Natalia Givojno on 20.12.22.
//

import UIKit

class QuizScoreHeaderView: UIView {

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .systemBlue
        return label
        
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
        self.backgroundColor = .white
      
    }
    
    private func setupConstraints() {
        
        headerLabel.snp.makeConstraints{make in
            make.top.bottom.left.right.equalToSuperview().inset(30)
            }
       
        
    }
    
    //MARK: - Public
    //функция configure которая принимает нашу модель Question из QuestionResponse
    func configure(totalScore: Int) {
        headerLabel.text = "Finally score: \(totalScore)"
        
    }
    
}





