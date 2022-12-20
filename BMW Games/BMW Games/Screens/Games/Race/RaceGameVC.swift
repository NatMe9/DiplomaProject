//
//  RaceGameVC.swift
//  BMW Games
//
//  Created by Natalia Givojno on 17.12.22.
//

import Foundation
import UIKit

class RaceGameVC: UIViewController {
    
    private let roadWidth: CGFloat = 250
    private var score: Int = 0
    
    private var road: UIView = {
        let road = UIView()
        road.backgroundColor = UIColor(red: 45/255, green: 64/255, blue: 70/255, alpha: 1.0)
        road.translatesAutoresizingMaskIntoConstraints = false
        return road
    }()
    
    private var scoreLabel: UILabel = {
            let scoreLabel = UILabel()
            scoreLabel.text = "0"
            scoreLabel.textAlignment = .center
            scoreLabel.textColor = .white
            scoreLabel.backgroundColor = UIColor.systemGray
            scoreLabel.translatesAutoresizingMaskIntoConstraints = false
            return scoreLabel
        }()
        
    private  var oneButton: UIButton = {
        let oneButton = UIButton()
        oneButton.backgroundColor = UIColor(red: 238/255, green: 4/255, blue: 5/255, alpha: 1.0)
        oneButton.setTitle("<<<", for: .normal)
        oneButton.translatesAutoresizingMaskIntoConstraints = false
        return oneButton
    }()
    
    private  var secondButton: UIButton = {
        let secondButton = UIButton()
        secondButton.backgroundColor = UIColor(red: 238/255, green: 4/255, blue: 5/255, alpha: 1.0)
        secondButton.setTitle(">>>", for: .normal)
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        return secondButton
    }()
    
    private var whiteLine: UIView = {
        let whiteLine = UIView()
        whiteLine.backgroundColor = .white
        whiteLine.translatesAutoresizingMaskIntoConstraints = false
        return whiteLine
    }()
    
    private var bmw: UIImageView = {
        let bmw = UIImageView()
        bmw.image = UIImage(named: "bmwi3")
        bmw.contentMode = .scaleToFill
        bmw.translatesAutoresizingMaskIntoConstraints = false
        return bmw
    }()
    
    private var stop: UIImageView = {
        let stop = UIImageView()
        stop.image = UIImage(named: "stop")
        stop.contentMode = .scaleToFill
        stop.translatesAutoresizingMaskIntoConstraints = false
        return stop
    }()
    
    private var bmwTopAnchor: NSLayoutConstraint?
    private var bmwLeadingAnchor: NSLayoutConstraint?
    private var bmwTrailingAnchor: NSLayoutConstraint?
    
    private var stopTopAnchor: NSLayoutConstraint?
    private var stopCenterX: NSLayoutConstraint?
    private var stopBottomAnchor: NSLayoutConstraint?
    
    private var timer: Timer?
    
    var scoreRes: ((Int) -> ())?
   
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
      
        setupViews()
        setupConstraints()
       
        setupOneButton()
        setupSecondButton()
        setupBMW()
        setupStop()
        createVerticalTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        oneButton.addCornerRadius()
        secondButton.addCornerRadius()
        scoreLabel.layer.masksToBounds = true
        scoreLabel.addCornerRadius()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Private
    @objc private func tapOneButton() {
        guard let bmwLeadingAnchor = bmwLeadingAnchor,
              let bmwTrailingAnchor = bmwTrailingAnchor else {
            return
        }
        bmwLeadingAnchor.constant -= 20
        bmwTrailingAnchor.constant -= 20
        if bmwLeadingAnchor.constant <= -25 {
            self.scoreRes?(self.score)
           
        }
    }
    
    @objc private func tapRightButton() {
        guard let bmwLeadingAnchor = bmwLeadingAnchor,
              let bmwTrailingAnchor = bmwTrailingAnchor else {
            return
        }
        bmwLeadingAnchor.constant += 20
        bmwTrailingAnchor.constant += 20
        if bmwTrailingAnchor.constant >= 25 {
            self.scoreRes?(self.score)

        }
    }
    
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(road)
        view.addSubview(scoreLabel)
        road.addSubview(whiteLine)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            road.topAnchor.constraint(equalTo: view.topAnchor),
            road.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            road.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            road.widthAnchor.constraint(equalToConstant: roadWidth)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            scoreLabel.leadingAnchor.constraint(equalTo: road.trailingAnchor, constant: 10),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            whiteLine.centerXAnchor.constraint(equalTo: road.centerXAnchor),
            whiteLine.topAnchor.constraint(equalTo: road.topAnchor, constant: 0),
            whiteLine.bottomAnchor.constraint(equalTo: road.bottomAnchor, constant: 0),
            whiteLine.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    private func setupOneButton() {
        view.addSubview(oneButton)
        
        NSLayoutConstraint.activate([
            oneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            oneButton.trailingAnchor.constraint(equalTo: road.leadingAnchor, constant: -15),
            oneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            oneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        oneButton.addTarget(self, action: #selector(tapOneButton), for: .touchUpInside)
    }
    

    private func setupSecondButton() {
        view.addSubview(secondButton)
        
        NSLayoutConstraint.activate([
            secondButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            secondButton.leadingAnchor.constraint(equalTo: road.trailingAnchor, constant: 15),
            secondButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            secondButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        secondButton.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
    }
 
    private func setupBMW() {
        road.addSubview(bmw)
        
        bmwTopAnchor = bmw.topAnchor.constraint(equalTo: road.topAnchor, constant: 500)
        bmwLeadingAnchor = bmw.leadingAnchor.constraint(equalTo: road.leadingAnchor, constant: roadWidth / 3)
        bmwTrailingAnchor = bmw.trailingAnchor.constraint(equalTo: road.trailingAnchor, constant: -roadWidth / 3)
        
        NSLayoutConstraint.activate([
            bmw.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        guard let bmwTopAnchor = bmwTopAnchor,
              let bmwLeadingAnchor = bmwLeadingAnchor,
              let bmwTrailingAnchor = bmwTrailingAnchor else {
            return
        }
        bmwTopAnchor.isActive = true
        bmwLeadingAnchor.isActive = true
        bmwTrailingAnchor.isActive = true
    }
    

    private func setupStop() {
        road.addSubview(stop)
        
        stopTopAnchor = stop.topAnchor.constraint(equalTo: road.topAnchor, constant: -30)
        stopCenterX = stop.centerXAnchor.constraint(equalTo: road.centerXAnchor, constant: -roadWidth / 4)
        stopBottomAnchor = stop.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100)
        
        NSLayoutConstraint.activate([
            stop.widthAnchor.constraint(equalToConstant: 50),
            stop.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        guard let stopTopAnchor = stopTopAnchor,
              let stopCenterX = stopCenterX,
              let stopBottomAnchor = stopBottomAnchor else {
            return
        }
        stopTopAnchor.isActive = true
        stopCenterX.isActive = true
        stopBottomAnchor.isActive = false
    }
    
    private func createVerticalTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] (timer) in
            self?.animateBottom()
            self?.positionStop()
            self?.score += 1
            self?.scoreLabel.text = String(self?.score ?? 0)
        }
    }
    
    private func animateBottom() {
        guard let stopTopAnchor = stopTopAnchor,
              let stopBottomAnchor = stopBottomAnchor else {
            return
        }
        stopTopAnchor.isActive = false
        stopBottomAnchor.isActive = true
        UIView.animate(withDuration: 2.5, delay: 0.0, options: .repeat) {
            self.road.layoutIfNeeded()
        } completion: { _ in
            self.stopCenterX?.constant = Bool.random() ? -self.roadWidth / 4 : self.roadWidth / 4
        }
    }
    
    private func positionStop() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] (timer) in
            
        
            if let pointStop = self?.stop.layer.presentation()?.frame.intersects(self?.bmw.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)) {
                if pointStop == true {
                    timer.invalidate()
                    self?.scoreRes?(self?.score ?? 0)
                    SaverRaceResultVC.getSaver.currentScore = (self?.score ?? 0)
                    SaverRaceResultVC.getSaver.saveRes(score: SaverRaceResultVC.getSaver.currentScore)

                  
                    self?.navigationController?.pushViewController(PersonalRaceScoreVC(), animated: true)
                }
            }
        }
    }
}
