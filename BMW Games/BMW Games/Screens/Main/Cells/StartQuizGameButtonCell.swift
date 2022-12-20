//
//  StartQuizGameButtonCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 17.12.22.
//

import UIKit

protocol StartQuizGameButtonCellOutput: AnyObject {
    func startQuizGameButtonCellDidSelect()
}

class StartQuizGameButtonCell: UITableViewCell {

    static var reuseID = "StartQuizGameButtonCell"
    
    weak var delegate: StartQuizGameButtonCellOutput?
    
    private lazy var startButton: UIButton = {
        
        var button = UIButton()
        button.setTitle("START QUIZ", for: .normal)
        button.backgroundColor = UIColor(red: 200/255, green: 45/255, blue: 43/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(startQuizGameAction), for: .touchUpInside)
        button.addShadow()
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    
    private func setupViews() {
        contentView.addSubview(startButton)
        
        self.selectionStyle = .none
    }
    
    private func setupConstraints() {
        
        startButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.bottom.equalToSuperview().inset(20)

        }
    }
    
    //MARK: - Public
    func configure(_ model: Category?) {
        
        if model != nil {
            startButton.isEnabled = true
        }
    }

    
    //MARK: - Actions
    @objc
    func startQuizGameAction() {
        delegate?.startQuizGameButtonCellDidSelect()
    }
    
}

