//
//  CheckButtonCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 5.12.22.
//

import UIKit

//вводим два состояния для кнопки
enum CheckButtonState {
    case normal // стартовое состояние
    case check // проверить ответ
    case next // след вопрос
}


protocol CheckButtonCellDelegate: AnyObject {
    
    func checkButtonCellNextQuestion(_ buttonState: CheckButtonState) //расширяем метод на два состояния кнопки
}

class CheckButtonCell: UITableViewCell {
    
    static var reuseID = "CheckButtonCell"
    
    //если передаем какой-то state - его нужно тут хранить
    var buttonState: CheckButtonState = .normal
    
    
    //var onNextQuestionAction: (()->())?  // делаем опциональный кложер - внешний экшн
    var delegate: CheckButtonCellDelegate?
    
    private lazy var checkButton: UIButton = {
        var button = UIButton()
        button.setTitle("Проверить", for: .normal)
        button.backgroundColor = UIColor(red:22/255, green:88/255, blue:142/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.addShadow()
        
        button.addTarget(self, action: #selector(nextQuestionAction), for: .touchUpInside)
        
        return button
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
        contentView.addSubview(checkButton)
        self.selectionStyle = .none //отключили нажатие на label под button
    }
    
    private func setupConstraints() {
        checkButton.snp.makeConstraints{make in
            make.top.bottom.left.right.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
    }
    
    //MARK: - Public
    //функция configure которая принимает нашу модель Question из QuestionResponse
    func configure(_ model: Question?, answerIsChecked: (value: Bool, count: Int)) {
        
        checkButton.isEnabled = answerIsChecked.value
       
        
    }
    //MARK: - Actions
    @objc func nextQuestionAction () { //внутренний экшн
        
        //onNextQuestionAction?() - через кложур реализация
        
        switch buttonState {
        case .normal:
            
            checkButton.setTitle("Следующий", for: .normal)
            buttonState = .check
            delegate?.checkButtonCellNextQuestion(buttonState) // - через delegate
            
        case .check:
            
            checkButton.setTitle("Проверить", for: .normal)
            buttonState = .next
            delegate?.checkButtonCellNextQuestion(buttonState) // - через delegate
            
        case .next:
            checkButton.setTitle("Следующий", for: .normal)
            buttonState = .check
            delegate?.checkButtonCellNextQuestion(buttonState) // - через delegate
        }
       
    }
}
