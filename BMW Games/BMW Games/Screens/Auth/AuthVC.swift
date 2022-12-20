//
//  AuthVC.swift
//  BMW Games
//
//  Created by Natalia Givojno on 17.12.22.
//

import UIKit
import FirebaseAuth
import SnapKit

enum AuthActivationTypeOf: Int {
    case logIn
    case registration
}

class AuthVC: UIViewController {

    var authActivationTypeOf: AuthActivationTypeOf? = .logIn

    private let helloLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "WELCOME in BMW Games"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.textColor = UIColor(red: 60/255, green: 80/255, blue: 90/255, alpha: 1.0)
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.image = UIImage(named: "bmw_1970_2")
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textColor = .white
        textField.font = UIFont.boldSystemFont(ofSize: 17)
        textField.backgroundColor = UIColor(red:69/255, green:153/255, blue:254/255, alpha: 1)
        textField.layer.cornerRadius = 5
        //ширина и цвет рамки
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.textColor = .white
        textField.font = UIFont.boldSystemFont(ofSize: 17)
        textField.backgroundColor = UIColor(red:69/255, green:153/255, blue:254/255, alpha: 0.8)
        textField.layer.cornerRadius = 5
        //ширина и цвет рамки
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let entryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = UIColor(red:22/255, green:88/255, blue:142/255, alpha: 0.8)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(entryButtonTapped), for: .touchUpInside)
        return button
    }()

    private let entryTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(red: 200/255, green: 45/255, blue: 43/255, alpha: 1.0), for: .normal)
        button.setTitle("Create account", for: .normal)
       
        button.addTarget(self, action: #selector(entryTypeButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        emailTextField.text = "12345@test.com"
//        passwordTextField.text = "12345"
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Private

    private func setupViews() {
        view.backgroundColor = .white //UIColor(red:184/255, green:202/255, blue:209/255, alpha: 1)
        view.addSubview(helloLabel)
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        emailTextField.addShadow()
        view.addSubview(passwordTextField)
        passwordTextField.addShadow()
        view.addSubview(entryButton)
        entryButton.addShadow()
        view.addSubview(entryTypeButton)
    }

    private func setupConstraints() {
        helloLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).inset(40)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
        }
    
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(helloLabel).inset(60)
            make.left.right.equalToSuperview().inset(50)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(60)
            make.left.right.equalToSuperview().inset(50)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
        }

        entryButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(50)
        }

        entryTypeButton.snp.makeConstraints { make in
            make.top.equalTo(entryButton).inset(60)
            make.left.right.equalToSuperview().inset(50)
        }
    }

    @objc private func entryButtonTapped() {
        switch authActivationTypeOf {
        case .logIn:
            authorizeToFirebase()
        case .registration:
            registrationToFirebase()
        case .none:
            return
        }
    }

    @objc private func entryTypeButtonTapped() {
        switch authActivationTypeOf {
        case .logIn:
            helloLabel.text = "Create account"
            entryButton.setTitle("Create account", for: .normal)
            entryTypeButton.setTitle("You already have an account", for: .normal)
            authActivationTypeOf = .registration
        case .registration:
            helloLabel.text = "LOGIN"
            entryButton.setTitle("SIGN IN", for: .normal)
            entryTypeButton.setTitle("Create account", for: .normal)
            authActivationTypeOf = .logIn
        case .none:
            return
        }
    }

    // MARK: - Navigation

    func showMainScreen() {
        let mainViewController = ScreenFactoryImpl().makeMainScreen()
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }

    func authorizeToFirebase() {
        Auth.auth().signIn(withEmail: "\(emailTextField.text ?? "")", password: "\(emailTextField.text ?? "")") { result, error in
            if let error = error {
                print(error.localizedDescription)
                let alertController = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showMainScreen()
            }
        }
    }

    func registrationToFirebase() {
        Auth.auth().createUser(withEmail: "\(emailTextField.text ?? "")", password: "\(emailTextField.text ?? "")") { result, error in
            if result != nil {
                let alertController = UIAlertController(title: "", message: "You have successfully registered", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: {
                    self.entryTypeButtonTapped()
                })
            }
            if let error = error {
                print(error.localizedDescription)
                let alertController = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
    }

    func logoutFromFirebase() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension UIView {
    func addShadow(shadowColor: UIColor = .black, offset: CGSize = .init(width: 3, height: 3), opacity: Float = 0.4, radius: CGFloat = 10) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func addCornerRadius() {
        layer.cornerRadius = layer.frame.height / 2
    }
    
}



