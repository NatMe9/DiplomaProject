//
//  PersonalScoreVC.swift
//  BMW Games
//
//  Created by Natalia Givojno on 19.12.22.
//

import UIKit

final class PersonalQuizScoreVC: UIViewController {
    
    lazy var totalScoreHeader = QuizScoreHeaderView()
    
    var scoreArchiver = ScoreArchiverImpl()
    
    var scoreModel: Score?
    
    var scores : [Score] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    //homekit
    lazy var homeBarButton: UIBarButtonItem = {
        let image = UIImage(systemName: "homekit")
        let button = UIBarButtonItem.init(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(homeBarButtonAction))
        return button
    }()
    
    
//если не lazy, то переменная создается раньше контроллера
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        //отдали на реализацию интерфейс на текущий контроллер
        tableView.dataSource = self
        tableView.delegate = self
        //назначаем ячейки
        tableView.register(QuizScoreCell.self, forCellReuseIdentifier: QuizScoreCell.reuseID)


        return tableView
    }()
    //MARK: - Lifecycle
    
    init(model: Score) {
        super.init(nibName: nil, bundle: nil)
      
        scoreModel = model
        
        scores = scoreArchiver.retrieve()
        
        scores.insert(model, at: 0)
        
        scoreArchiver.save(scores)
        totalScoreHeader.configure(totalScore: model.correctQuestionIds.count)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    
    //MARK: - Private
    
   private func setupViews() {
      
        view.addSubview(tableView)
       navigationItem.rightBarButtonItem = homeBarButton
       navigationController?.isNavigationBarHidden = false
       navigationItem.hidesBackButton = true
    }
     private func setupConstraints() {
        tableView.snp.makeConstraints{ make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }

//MARK: - Action
@objc func homeBarButtonAction() {
    let mainVC = ScreenFactoryImpl().makeMainScreen()
    navigationController?.pushViewController(mainVC, animated: true)

}
}
extension PersonalQuizScoreVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    //создание ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuizScoreCell.reuseID, for: indexPath) as? QuizScoreCell else {return UITableViewCell()}
       
        let score = scores[indexPath.row]
        cell.configure(score)
      
        
        return cell
    }
}

extension PersonalQuizScoreVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       return totalScoreHeader
        
    }
}
 

    
    

