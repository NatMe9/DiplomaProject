//
//  MainVC.swift
//  BMW Games
//
//  Created by Natalia Givojno on 17.12.22.
//

import UIKit

enum CategorySectionType: Int, CaseIterable {
    
    case category //CategoryCell
    case startQuizButton //StartQuizGameButtonCell
    case startRaceButton //StartRaceGameButtonCell
    case nemBMWImage // BMWImageCell
}

final class MainVC: UIViewController {
    
    
    var questionProvider = QuestionsProviderImpl.shared
    
    var categories: [Category] = [] //вернули категории
    
    var currentCategory: Category?
    
    var zeroView = ZeroView.init(jsonName: "car-loader")
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
        tableView.register(StartQuizGameButtonCell.self, forCellReuseIdentifier: StartQuizGameButtonCell.reuseID)
        tableView.register(StartRaceGameButtonCell.self, forCellReuseIdentifier: StartRaceGameButtonCell.reuseID)
        tableView.register(BMWImageCell.self, forCellReuseIdentifier: BMWImageCell.reuseID)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zeroView.show()
        
        setupViews()
        setupConstraints()
        
        questionProvider.fetchAllQuestions {
            
            self.questionProvider.shuffleQuestions()
            self.categories = self.questionProvider.fetchAllCategories()
            self.tableView.reloadData()
            self.zeroView.hide()
        }
        
    }
    
    // MARK: - Private
    
    private func setupViews() {
        view.addSubview(tableView)
        navigationItem.hidesBackButton = true
        view.addSubview(zeroView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        zeroView.pinEdgesToSuperView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.zeroView.hide()
        }
    }
    
    // MARK: - Navigation
    
    func showStandardGameScreen() {
        let quizGameVC = ScreenFactoryImpl().makeQuizGameScreen()
        self.navigationController?.pushViewController(quizGameVC, animated: true)
    }
    
    
    func showRaceGameScreen() {
        let raceGameVC = ScreenFactoryImpl().makeRaceGameScreen()
        self.navigationController?.pushViewController(raceGameVC, animated: true)
    }
    
}


extension MainVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CategorySectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellType = CategorySectionType.init(rawValue: indexPath.section) {
            
            switch cellType {
                
            case .category:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID, for: indexPath) as? CategoryCell else { return UITableViewCell() }
                print(categories)
                
                cell.delegate = self
                cell.configure(categories)
                
                return cell
                
            case .startQuizButton:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StartQuizGameButtonCell.reuseID, for: indexPath) as? StartQuizGameButtonCell else { return UITableViewCell() }
                
                cell.delegate = self
                cell.configure(currentCategory)
                
                return cell
                
            case .startRaceButton:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StartRaceGameButtonCell.reuseID, for: indexPath) as? StartRaceGameButtonCell else { return UITableViewCell() }
                
                cell.delegate = self
                
                
                return cell
            case .nemBMWImage:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: BMWImageCell.reuseID, for: indexPath) as? BMWImageCell else { return UITableViewCell() }
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        
        if let categorySectionType = CategorySectionType.init(rawValue: indexPath.section) {
            switch categorySectionType {
                
            case .category:
                return CGFloat(100)
            case .startQuizButton:
                return CGFloat(100)
            case .startRaceButton:
                return CGFloat(100)
            case .nemBMWImage:
                return CGFloat(400)
            }
        }
        return CGFloat()
    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .black
            header.textLabel?.numberOfLines = 0
            header.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionType = CategorySectionType(rawValue: section) {
            switch sectionType {
            case .category:
                return "QUIZ CATEGORY"
            case .startQuizButton:
                return ""
            case .startRaceButton:
                return ""
            case .nemBMWImage:
                return ""
            }
        }
        return ""
    }
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return CGFloat(100)
    //    }
}

extension MainVC: StartQuizGameButtonCellOutput {
    
    func startQuizGameButtonCellDidSelect() {
        showStandardGameScreen()
    }
}

extension MainVC: StartRaceGameButtonCellOutput {
    func startRaceGameButtonCellDidSelect() {
        showRaceGameScreen()
    }
}


extension MainVC: CategoryCellOutput {
    
    func categoryCellDidSelect(_ category: Category) {
        
        currentCategory = category
        
        for item in categories {
            if item.name == category.name {
                item.selected = true
            } else {
                item.selected = false
            }
        }
        
        questionProvider.fetchQuestion(by: category) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
}


