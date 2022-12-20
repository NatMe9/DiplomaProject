//
//  AnswerCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 5.12.22.
//

import UIKit

protocol AnswerCellDelegate: AnyObject {
    func answerCellSelectAnswer()
}

class AnswerCell: UITableViewCell {

    static var reuseID = "AnswerCell"

    var currentAnswer: Answer? = nil
    var canTapAnswer: Bool = true

    var delegate: AnswerCellDelegate?
     

    private lazy var backgroundCellView: UIView = {
        var view = UIView()
        view.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        view.layer.borderWidth = 3.0
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        
        
        return view
    }()
    
    private lazy var answerButton: UIButton = {
        
        var button = UIButton()
        button.backgroundColor = .clear
   
        button.addTarget(self, action: #selector(answerButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0 //не в одну строку
        label.lineBreakMode = .byWordWrapping //разбить по словам т.е. перенос по словам
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
        contentView.addSubview(answerLabel)
        contentView.addSubview(answerButton)
    }

    private func setupConstraints() {

        backgroundCellView.snp.makeConstraints{make in
            make.top.bottom.left.right.equalTo(contentView).inset(5)
        }

        answerLabel.snp.makeConstraints{make in
            make.top.bottom.left.right.equalTo(backgroundCellView).inset(20)
        }

        answerButton.snp.makeConstraints {make in
            make.top.bottom.left.right.equalToSuperview()
        }

    }

    //MARK: - Public
    //функция configure которая принимает нашу модель Question из QuestionResponse
    func configure(_ model: Answer?, buttonState: CheckButtonState, answerIsCorrect: Bool, canTapAnswer: Bool) {

        self.currentAnswer = model
        self.canTapAnswer = canTapAnswer

        answerLabel.text = model?.text ?? "" // ?? "" - иначе пустая строка


    
        switch buttonState {
        case .normal, .next:
            
            if model?.isSelected == true {

                backgroundCellView.backgroundColor = UIColor(red:129/255, green:196/255, blue:255/255, alpha: 1)
                answerLabel.textColor = .black
            } else {
                backgroundCellView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
                answerLabel.textColor = .black
                backgroundCellView.backgroundColor = .clear
            }
        case .check:
            
            //над условие - где выполняется реализация доработки состояния ответа если он сразу выбран верным(то только его подсветить зеленым)
            if answerIsCorrect == true {
                if let isCorrect = model?.isCorrect, isCorrect == true {
                   
                    backgroundCellView.layer.borderColor = UIColor(red:4/255, green:179/255, blue:114/255, alpha: 1).cgColor
                    backgroundCellView.backgroundColor = .white
                    answerLabel.textColor = .black
                } else {
                    backgroundCellView.backgroundColor = .white
                    answerLabel.textColor = .lightGray
                }
                
                return
            }
            //реализация если правильный то зеленый - если нет красная рамка
            if let isCorrect = model?.isCorrect, isCorrect == true {
               
                backgroundCellView.layer.borderColor = UIColor(red:4/255, green:179/255, blue:114/255, alpha: 1).cgColor
                backgroundCellView.backgroundColor = .white
                answerLabel.textColor = .black
            } else {
                backgroundCellView.layer.borderColor = UIColor(red:231/255, green:34/255, blue:46/255, alpha: 1).cgColor
                backgroundCellView.backgroundColor = .white
                answerLabel.textColor = .lightGray
            }
        }
    }
    
       
    //MARK: - Actions

    @objc func answerButtonAction() {
        print("answerButtonAction")
        
//        if answerIsChecked.count == 1 {
//            checkButton.isEnabled = false
//        }
        if canTapAnswer == true || currentAnswer?.isSelected == true {
            currentAnswer?.isSelected = currentAnswer?.isSelected == false ? true : false

            delegate?.answerCellSelectAnswer()
        }
    }
}

    

    
  
