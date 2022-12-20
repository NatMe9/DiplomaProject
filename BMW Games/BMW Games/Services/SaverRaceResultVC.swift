//
//  Saver.swift
//  BMW Games
//
//  Created by Natalia Givojno on 19.12.22.
//

import Foundation

class SaverRaceResultVC {
    
    let defaults = UserDefaults.standard
    
    static let getSaver = SaverRaceResultVC()
    
    var currentScore: Int = 0
    
    struct UserNameScore:Codable {
      
        var score: Int
        var dateString: String
        var name:String {
            return "Your score: \(score), Date: \(dateString)"
        }
    }
    
    var resulti:[UserNameScore]{
        get {
           //получаем результат
            if let data = defaults.value(forKey: "results") as? Data {
                return try! PropertyListDecoder().decode([UserNameScore].self, from: data)
            } else {
                return [UserNameScore]()
            }
        }
        set {
            //сохраняем значение, которое приходит когда меняем результат
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "results")
            }
        }
    }

    func saveRes(score:Int) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.MM.yy hh:mm"
        let dateString = dateFormatter.string(from: Date())
        
        let result = UserNameScore(score: score, dateString: dateString)
        resulti.insert(result, at: 0)

    }
}




