//
//  JsonService.swift
//  BMW Games
//
//  Created by Natalia Givojno on 7.12.22.
//

import Foundation

//правильное офомление сервиса через протокол: что значит что у сервиса есть внутренний интерфейс с методом который выгружает JSON и парсит
protocol JsonService {
    func loadJson(filename fileName: String) -> [Question]?
}
// сервис который грузит JSON
class JsonServiceImpl: JsonService {
    
    func loadJson(filename fileName: String) -> [Question]? {
 
       // С помощью этого кода мы получаем ссылку на файл JSON и получаем его содержимое в виде необработанных данных. Созданный  URL-адрес является локальным для файла на вашем компьютере (bundle - это наше приложение)
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                //Сначала мы включаем всю нашу логику в оператор do-catch , потому что получение данных из JSON потенциально может вызвать ошибку.
                //Инструкция do-catch для обработки ошибок. Если выдается ошибка в коде условия do, она соотносится с условием catch для определения того, кто именно сможет обработать ошибку.
                let decoder = JSONDecoder()
                //Класс JSONDecoder декодирует экземпляры типа данных из объектов JSON.С этим классом обычно используют метод decode_:from:). Этот метод принимает ответ JSON в виде типа данных и универсального типа, соответствующего протоколу Decodable.
                let jsonResponse = try decoder.decode(QuestionsResponse.self, from: data)
                return jsonResponse.items
                
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
