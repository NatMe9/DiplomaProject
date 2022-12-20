//
//  ViewController.swift
//  BMW Games
//
//  Created by Natalia Givojno on 2.12.22.
//

import UIKit
import SnapKit

// определении кол-ва секций: .allCases.count - 1 вопрос это 3 секции (сам вопрос, варианты ответов, кнопка проверить/продолжить)

enum QuestionSectionType: Int, CaseIterable {
    //Типы, соответствующие протоколу CaseIterable, обычно представляют собой перечисления без связанных значений. При использовании типа вы можете получить доступ к коллекции всех случаев типа, используя свойство типа
    case question //QuestionTextCell
    case answer //AnswerCell
    case button //CheckButtonCell
}
// определение кол-ва ячеек в первой секции question
enum QuestionType: Int, CaseIterable {
    case text
    case image
}

class QuizGameVC: UIViewController {
    
    var provider: QuestionsProvider

    
    lazy var questionNumberHeader = QuestionNumberHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        //отдали на реализацию интерфейс на текущий контроллер
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none // убрали полоски разделители таблицы
        
        //назначаем header
        // tableView.tableHeaderView = questionNumberHeader
        
        //назначаем ячейки
        tableView.register(QuestionTextCell.self, forCellReuseIdentifier: QuestionTextCell.reuseID)
        tableView.register(QuestionImageCell.self, forCellReuseIdentifier: QuestionImageCell.reuseID)
        tableView.register(AnswerCell.self, forCellReuseIdentifier: AnswerCell.reuseID)
        tableView.register(CheckButtonCell.self, forCellReuseIdentifier: CheckButtonCell.reuseID)
        
        return tableView
    }()
    
    
    //MARK: - Lifecycle
    
    init(questionProvider: QuestionsProvider) {
        
        self.provider = questionProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        fetchQuestions()
    }
    
    
    //MARK: - Request
    private func fetchQuestions() {
        //        //подрубаем jsonService и выгружаем из файла "questions" - эта штука вся возвращает [Question]? , поэтому надо иметь var questions
        //        questions = jsonService?.loadJson(filename: "questions") ?? []
        //        // ?? [] - лучше развернуть пустой массив
        //        currentQuestion = questions.first //захардкодили, то что текущий вопрос просто первый от полученного массива вопросов
        
        //        provider.fetchAllQuestions { [self] in
//    }
        
        let (_, number, count) = self.provider.nextQuestion() //(question, number, count)
        
        questionNumberHeader.configure(currentQuestion: number, numberOfQuestions: count)
        tableView.reloadData() //Перезагружает строки и разделы табличного представления

    }
    
    
    //MARK: - Private
    private func setupViews() {
        //добавляем таблицу на view
        navigationController?.isNavigationBarHidden = true
        view.addSubview(tableView)
        
    }
    
    private func setupConstraints() {
        //растягиваем размер таблицы на view
        tableView.snp.makeConstraints {make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(-70)
        }
        
    }
    
    
}
//принимаем протокол dataSource с двумя обязательными методами numberOfRowsInSection и cellForRowAt
extension QuizGameVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionType = QuestionSectionType.init(rawValue: section)
        
        switch sectionType {
        case .question: return questionNumberHeader
            
        default: return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = QuestionSectionType.init(rawValue: section)
        switch sectionType {
        case .question: return 100
            
        default: return 0
        }
    }
    
    //кол-во секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return QuestionSectionType.allCases.count //через протокол CaseIterable получили 3 секции
    }
    
    //кол-во ячеек из enum
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //у нас есть секция sectionType, она опциональная поэтому используем init для опционала. Может вернуть nil - поэтому if let используем.
        let sectionType = QuestionSectionType.init(rawValue: section)
        
        switch sectionType {
        case .question:
            return QuestionType.allCases.count //наши 2 ячейки text и image
        case .answer:
            return provider.currentQuestion?.answers.count ?? 0 //answer зависит от кол-ва элементов в массиве
        default: return 1 //а все остальные case по одной ячейке
            
            
        }
    }
    
    //создаем ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //проверяем по секции - если это первая, то выкатываем ячейку c текстом вопроса через метод configure из QuestionTextCell, далее анологично
        
        let sectionType = QuestionSectionType.init(rawValue: indexPath.section)
        
        switch sectionType {
        case .question:
            
            //расширяем секцию question, там где приходит (мы находимся внутри секции где 2 ячейки - поэтому row )
            if let questionType = QuestionType(rawValue: indexPath.row) {
                switch questionType {
                case .text:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTextCell.reuseID, for: indexPath) as? QuestionTextCell else { return UITableViewCell() }
                    
                    cell.configure(provider.currentQuestion)
                    
                    return cell
                    
                case .image:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionImageCell.reuseID, for: indexPath) as? QuestionImageCell else { return UITableViewCell() }
                    
                    cell.configure(provider.currentQuestion)
                    
                    return cell
                }
            }
            
            
        case .answer:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.reuseID, for: indexPath) as? AnswerCell else { return UITableViewCell() }
            //надо вытащить ответы к первому currentQuestion
            let answer = provider.currentQuestion?.answers[indexPath.row]
            
            cell.configure(answer, buttonState: provider.checkButtonState, answerIsCorrect: provider.answerIsCorrect, canTapAnswer: provider.canTapAnswer)
            cell.delegate = self
            return cell
            
        case .button:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckButtonCell.reuseID, for: indexPath) as? CheckButtonCell else { return UITableViewCell() }
            
            cell.configure(provider.currentQuestion, answerIsChecked: provider.answerIsChecked)
            
            ////реализация через кложер
            //                cell.onNextQuestionAction = {
            //                    self.questionProvider?.nextQuestion()
            //                    self.tableView.reloadData() //Перезагружает строки и разделы табличного представления
            //            }
            //реализация через делегат
            
            cell.delegate = self
            
            return cell
            
        default: return UITableViewCell()
        }
        
        return UITableViewCell()
    }
}

//необходимо рассчитать высоту ячейки с image
extension QuizGameVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let sectionType = QuestionSectionType.init(rawValue: indexPath.section) {
            switch sectionType {
            case .question:
                
                if let questionType = QuestionType(rawValue: indexPath.row) {
                    switch questionType {
                    case .text:
                        return provider.currentQuestion?.text == "" ? 0 : UITableView.automaticDimension // если равен пустоте - то высота 0 иначе automatic
                    case .image:
                        return provider.currentQuestion?.image == "" ? 0 : UIScreen.main.bounds.width //захардкодили квадратную картинку
                    }
                }
                
            default: return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
    
}

//UITableView - IndexPath дает нам понять где конкретно находится ячейка таблицы, в какой секции(indexPath.section) и какой по счету в этой секции (indexPath.row)

//MARK: - Navigation
extension QuizGameVC {
    func showPersonalQuizScoreScreen() {
        
        let category = provider.questions.first?.category ?? ""
        
        let progress: Float = Float(provider.numberOfCorrectQuestions)/Float(provider.questions.count)
        
        let correctAnswers: Float = Float(provider.numberOfCorrectQuestions)
        
        let allQuestion: Float = Float(provider.questions.count)
        
        let percent: String = "\(Int(progress * 100))%"
        
        
        let scoreModel = Score.init(category: category, progress: progress, correctAnswers: correctAnswers, allQuestion: allQuestion, percent: percent, correctQuestionIds: provider.correctQuestionIds)
        
        
        let personalQuizScoreVC = PersonalQuizScoreVC.init(model: scoreModel)
        navigationController?.pushViewController(personalQuizScoreVC, animated: true)
    }
    
}

//реализация через делегат
extension QuizGameVC: CheckButtonCellDelegate {
    
    func countCorrectQuestion() {
        
        var isCorrect = true
        let answers = provider.currentQuestion?.answers ?? []
        //если он неправильный
        for answer in answers {
            if answer.isCorrect != answer.isSelected {
                isCorrect = false
                
                //то элемент надо удалить из подсчета - если неправильный ответ
                if let correctId = provider.currentQuestion?.id {
                    
                    //прочитали массив - получили id
                    var ids = provider.correctQuestionIds
                    
                    //ищем неправильный ответ - убавили на 1 id
                    let uncorrectId = provider.currentQuestion?.id ?? 0
                    if let indexToRemove = ids.firstIndex(where: {$0 == uncorrectId }) {
                        ids.remove(at: indexToRemove)
                    }
                    
                    
                    //локальный массив сохранили в storage массив
                    provider.correctQuestionIds = ids
                    
                    print(provider.correctQuestionIds)
                }
                
            }
        }
        //если он правильный
        if isCorrect == true {
            provider.numberOfCorrectQuestions += 1
            
            if let correctId = provider.currentQuestion?.id{
                
                //прочитали массив - получили id и положили в локальную переменную
                var ids = provider.correctQuestionIds
                
                let correctId = provider.currentQuestion?.id ?? 0
                
                ids.append(correctId)
                
                //Сохраняем
                provider.correctQuestionIds = Array(Set(ids)) //чистим id
                
            }
        }
    }
    
    func checkButtonCellNextQuestion(_ buttonState: CheckButtonState) {
        
        provider.checkButtonState = buttonState
        
        switch buttonState {
            
        case .normal: break
        case .check:
            
            countCorrectQuestion()
            
            tableView.reloadData()
            
        case .next:
            //переход на след вопрос
            let (question, number, count) = provider.nextQuestion()
            questionNumberHeader.configure(currentQuestion: number, numberOfQuestions: count)
            
            
            if question == nil {
                showPersonalQuizScoreScreen()
            }
        }
        tableView.reloadData()
    }
    
}

extension QuizGameVC: AnswerCellDelegate {
    func answerCellSelectAnswer() {
        
        tableView.reloadData()
    }
}

