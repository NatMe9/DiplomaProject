//
//  AppDelegate.swift
//  BMW Games
//
//  Created by Natalia Givojno on 2.12.22.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        configureFirebase()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let authVC = ScreenFactoryImpl().makeAuthScreen()
        let navigationController = UINavigationController(rootViewController: authVC)
        
        window?.rootViewController = navigationController
//        window?.rootViewController = PersonalRaceScoreVC()
        window?.makeKeyAndVisible()
        
        return true
    }

    func configureFirebase() {
        FirebaseApp.configure()
    }


}
//quizGameVC.jsonService = JsonServiceImpl() // сделали Dependency injection через инициализатор - принцип Solid
//Dependency injection(внедрение зависимостей) - это внедрение зависимостей в объект вместо возложения на объект ответственности за создание своих зависимостей. Или вы даете объекту его переменные экземпляра вместо того, чтобы создавать их в объекте
