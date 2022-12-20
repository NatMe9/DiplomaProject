//
//  ScoreCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 19.12.22.
//

import UIKit

final class QuizScoreCell: UITableViewCell {
    
    static let reuseID = "QuizScoreCell"
    
    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "50% (5/10)"
        return label
    }()
    
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        return label
    }()
    
    private var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_img_1")
        return imageView
    }()
    
    private var scoreProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.25
        return progressView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Public
    
    func configure(_ model: Score) {
        categoryLabel.text = model.category
        
        let correct = Int(model.correctAnswers)
        let all = Int(model.allQuestion)
        
       // "50% (5/10)" -  //как получить 50% 
        scoreLabel.text = model.percent + " (\(correct)/\(all))" + "Finally score: \(model.correctQuestionIds.count)"

        scoreProgressView.progress = model.progress
    }
    
    private func setupView() {
        contentView.addSubview(scoreLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryImageView)
        contentView.addSubview(scoreProgressView)
    }
    
    private func setupConstrains() {
            categoryImageView.snp.makeConstraints { make in
                make.left.equalTo(contentView.snp.left).inset(20)
                make.width.height.equalTo(50)
                make.centerY.equalTo(contentView.snp.centerY)
            }
            
            categoryLabel.snp.makeConstraints { make in
                make.top.equalTo(contentView).inset(20)
                make.left.equalTo(categoryImageView.snp.right).offset(20)

                make.right.equalTo(contentView).inset(20)
            }
            
            scoreLabel.snp.makeConstraints { make in
                make.top.equalTo(categoryLabel.snp.bottom).offset(20)
                make.left.equalTo(categoryImageView.snp.right).offset(20)
                make.right.equalTo(contentView.snp.right).inset(20)

            }
            
            scoreProgressView.snp.makeConstraints { make in
                make.top.equalTo(scoreLabel.snp.bottom).offset(20)
                make.left.equalTo(categoryImageView.snp.right).offset(20)
                make.right.equalTo(contentView).inset(20)

                make.bottom.equalTo(contentView.snp.bottom).inset(20)
            }
        }
    
}
