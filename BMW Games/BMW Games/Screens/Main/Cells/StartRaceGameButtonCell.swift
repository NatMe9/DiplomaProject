//
//  StartRaceGameButtonCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 19.12.22.
//

import UIKit


protocol StartRaceGameButtonCellOutput: AnyObject {
    func startRaceGameButtonCellDidSelect()
}

class StartRaceGameButtonCell: UITableViewCell {

    static var reuseID = "StartRaceGameButtonCell"
    
    weak var delegate: StartRaceGameButtonCellOutput?
    
    private lazy var startButton: UIButton = {
        
        var button = UIButton()
        button.setTitle("START RACE", for: .normal)
        button.backgroundColor = UIColor(red: 200/255, green: 45/255, blue: 43/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.isEnabled = true
        button.addTarget(self, action: #selector(startRaceGameAction), for: .touchUpInside)
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
            //make.height.equalTo(50)
        }
    }
    
    //MARK: - Public
    func configure(_ model: Category?) {
        
       
    }
//?????????????????
    
    //MARK: - Actions
    @objc
    func startRaceGameAction() {
        delegate?.startRaceGameButtonCellDidSelect()
    }
    
}



