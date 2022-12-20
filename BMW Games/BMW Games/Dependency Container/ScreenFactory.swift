//
//  ScreenFactory.swift
//  BMW Games
//
//  Created by Natalia Givojno on 17.12.22.
//

import Foundation
import UIKit

protocol ScreenFactory {
    
    func makeQuizGameScreen() -> QuizGameVC
    func makeRaceGameScreen() -> RaceGameVC
    func makeAuthScreen() -> AuthVC
    func makeMainScreen() -> MainVC
    
}

class ScreenFactoryImpl: ScreenFactory {
   
    func makeQuizGameScreen() -> QuizGameVC {
        //let jsonService = JsonServiceImpl()
        
        let questionProvider = QuestionsProviderImpl.shared
        
        let quizGameVC = QuizGameVC(questionProvider: questionProvider)
        return quizGameVC
    }
    
    
    func makeRaceGameScreen() -> RaceGameVC {
        let raceGameVC = RaceGameVC()
        return raceGameVC
    }
    
    func makeAuthScreen() -> AuthVC {
        let authVC = AuthVC()
        return authVC
    }
    
    func makeMainScreen() -> MainVC {
        let mainVC = MainVC()
        return mainVC
    }
    
    
}
