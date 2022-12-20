//
//  QuestionsProvider.swift
//  BMW Games
//
//  Created by Natalia Givojno on 15.12.22.
//
//если делаем текущий сервис singleton, то выгоружаем вопросы в менюшке
import Foundation
import FirebaseDatabase
//Этот сервис - сервис-фасад, который включает в себя JsonService
//правильное офомление сервиса через протокол: что значит что у сервиса есть внутренний интерфейс
protocol QuestionsProvider {
   
    var allQuestions: [Question] {get set} // все вопросы
    //для реализации подсчета вопросов 5 из 10 например - добавляем  var questions
    var questions: [Question] {get set} // текущий список вопросов
    
    var activeQuestions: [Question] {get set}
    
    var correctQuestionIds: Array<Int> {get set}
    
    var checkButtonState: CheckButtonState {get set} // ответ выбран(нейтрально), если выбран (красные/зеленые)

    var currentQuestion: Question? {get set}  //текущий вопрос
    
    var answerIsChecked: (Bool, Int) {get} //вопрос отвечен правильно
    
    var answerIsCorrect: Bool {get}//узнаем заранее, что вопрос отвечен правильно
    
    var canTapAnswer: Bool {get}
    
    var numberOfCorrectQuestions: Int {get set}
    
    func nextQuestion() -> (Question?, Int, Int)
    
    func fetchAllLocalQuestions()  // получить все локальные вопросы
   
    func fetchAllQuestions( completion: @escaping ()->())
    
    func shuffleQuestions()
}

class QuestionsProviderImpl: QuestionsProvider  {
    
    private init() {}  //делаем текущий сервис singleton
    
    static let shared = QuestionsProviderImpl()  //делаем текущий сервис singleton
    
    var allQuestions: [Question] = [] //выгрузили все вопросы
    
    var questions: [Question] = []
    
    var activeQuestions: [Question] = []
    
    var correctQuestionIds: [Int] {
        
      //считывание массива из UserDefaults(локальное хранилище данных в .xml)
        get {
            let array = UserDefaults.standard.array(forKey: "correctQuestionIds") as? [Int] ?? []
           return array
            
        }
       //сохранение
        set {
            UserDefaults.standard.set(newValue, forKey: "correctQuestionIds")
        }
    }
    
    var currentQuestion: Question? = nil
    
    var checkButtonState: CheckButtonState = .normal
    
    var numberOfCorrectQuestions = 0
    
    var jsonService = JsonServiceImpl() //если singleton то будем внедрять json внутрь
    
//    init(jsonService: JsonService) {
//        self.jsonService = jsonService
//    }
    
    var canTapAnswer: Bool {
        let (_, selectedCount) = answerIsChecked
        if selectedCount >= 1 {
            return false
        }
           return true
           
    }
    
    var answerIsCorrect: Bool {
        
        let answers = currentQuestion?.answers ?? []
        
        for answer in answers {
            if answer.isCorrect != answer.isSelected {
                return false
            }
        }
        return true
    }
    
    
    var answerIsChecked: (Bool, Int) {
        
        var selectedCount = 0
        var isSelected = false
        let answers = currentQuestion?.answers ?? []
        for answer in answers {
            if answer.isSelected == true {
                isSelected = true
                selectedCount += 1
            }
        }
        return (isSelected, selectedCount)
    }
    
    
    func fetchAllLocalQuestions() {
        
        if let questions = jsonService.loadJson(filename: "questions") {
            allQuestions = questions // кладем вопросы из json в список всех вопросов
            self.questions = questions // список текущих вопросов
        }
    
    }
    
    func fetchQuestion(by category: Category, completion: @escaping ()->()) {
        
        questions = allQuestions.filter { $0.category == category.name }
        activeQuestions = questions
        
        completion()
    }
    
    func fetchAllCategories() -> [Category] {
        //вычленяем category из вопросов - структура данных фильтрующая все повторяющиеся категории, положим их в set и из set трансформируем в string
        
        var categories: Set<String> = []
        for question in allQuestions {
            categories.insert(question.category) //добавляем category из модели в categories
        }
        
        let sortedCategories = categories.sorted() //сортируем категории по алфавиту 
        
        var result: [Category] = []
        for categoryName in sortedCategories {             //проходим по отсортированным категориям
            let object = Category.init(name: categoryName)
            result.append(object)   //добавляем 
        }
        
        return result
    }
    
    
    //парсим вопросы из FireBase Database
    func fetchAllQuestions( completion: @escaping ()->()) {
        
        let ref = Database.database().reference()
        
        ref.child("items").observe(.value) { snapshot in
            
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            print(snapshot)
            print(snapshot.data, type(of: snapshot.data))
            
            let objects: [Question] = children.compactMap { snapshot in
                
                return try? JSONDecoder().decode(Question.self, from: snapshot.data!)

            }

            self.allQuestions = objects //список всех вопросов
            self.questions = objects //список активных вопросов
            
            completion()
        }
        
    }
    
    //выдает след question выпиливая предыдущий
    func nextQuestion() -> (Question?, Int, Int) { // question, number, count
        
        currentQuestion = activeQuestions.first
        self.activeQuestions = Array(activeQuestions.dropFirst())
        return (currentQuestion,  questions.count - activeQuestions.count, questions.count)
        
    
    }
    
    func shuffleQuestions() {
        allQuestions.shuffle()
    }
}

extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? { data?.string }
}
extension Data {
    var string: String? { String(data: self, encoding: .utf8) }
}
