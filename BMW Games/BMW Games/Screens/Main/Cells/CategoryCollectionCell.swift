//
//  CategoryTextCollectionCell.swift
//  BMW Games
//
//  Created by Natalia Givojno on 17.12.22.
//

import UIKit

protocol CategoryCollectionCellOutput: AnyObject {
    func categoryCollectionCellDidSelect(_ category: Category)
}

class CategoryCollectionCell: UICollectionViewCell {
    
    static var reuseID = "CategoryTextCollectionCell"
    
    weak var delegate: CategoryCollectionCellOutput? //controller
    
    var category: Category?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .systemBackground
        label.backgroundColor = UIColor(red: 16/255, green: 52/255, blue: 130/255, alpha: 1.0)
        return label
    }()
    
    private lazy var titleButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(titleButtonAction), for: .touchUpInside)
        button.addShadow()
        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public
    func configure(model: Category) {
        
        self.category = model
        
        titleLabel.text = model.name
        
        if model.selected {
            titleLabel.backgroundColor = UIColor(red: 0/255, green: 143/255, blue: 219/255, alpha: 1.0) //выбран
        } else {
            titleLabel.backgroundColor = UIColor(red: 16/255, green: 52/255, blue: 130/255, alpha: 1.0) // не выбран
        }
    }

    // MARK: - Private

    private func setupViews() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {make in
            make.top.left.right.bottom.equalTo(contentView).inset(15)
        }
        
        titleButton.snp.makeConstraints {make in
            make.top.left.right.bottom.equalTo(contentView).inset(15)
        }
    }
    
    // MARK: - Actions
    @objc func titleButtonAction() {
        
        if let category = category {
            category.selected = true
            delegate?.categoryCollectionCellDidSelect(category)
        }

    }
    
}
