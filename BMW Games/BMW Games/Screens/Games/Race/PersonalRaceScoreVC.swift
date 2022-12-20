//
//  PersonalRaceScoreVC.swift
//  BMW Games
//
//  Created by Natalia Givojno on 19.12.22.
//

import UIKit


    class PersonalRaceScoreVC: UIViewController {
    //если не lazy, то переменная создается раньше контроллера
        lazy var tableView: UITableView = {
            var tableView = UITableView()
            //отдали на реализацию интерфейс на текущий контроллер
            tableView.dataSource = self
            tableView.delegate = self
            

            return tableView
        }()
        
        //homekit
        lazy var homeBarButton: UIBarButtonItem = {
            let image = UIImage(systemName: "homekit")
            let button = UIBarButtonItem.init(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(homeBarButtonAction))
            return button
        }()
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
           
            setupViews()
            setupConstraints()
        }
        // MARK: - Private
       private func setupViews() {
           navigationItem.rightBarButtonItem = homeBarButton
           navigationController?.isNavigationBarHidden = false
           navigationItem.hidesBackButton = true
            view.addSubview(tableView)
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


extension PersonalRaceScoreVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SaverRaceResultVC.getSaver.resulti.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        var cell: UITableViewCell!
        if let dCell = tableView.dequeueReusableCell(withIdentifier: "dCell"){
            cell = dCell
        }else{
            cell = UITableViewCell()
        }
        
        cell.textLabel!.text = SaverRaceResultVC.getSaver.resulti[indexPath.row].name
        return cell
    }
    
    func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


     

        
        

