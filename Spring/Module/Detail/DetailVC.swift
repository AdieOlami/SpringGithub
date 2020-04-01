//
//  DetailVC.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    lazy var navLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nav: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var backBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
        return view
    }()
    
    lazy var selectedImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var usernameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var followersLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var reposLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [followersLabel, reposLabel])
        view.alignment = .leading
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var presenter: DetailsContract.Presenter!
//    fileprivate var repos: [ReposItems] = [ReposItems]()
    fileprivate var followers: [Items] = [Items]()
    var user = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        layout()
        logic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        presenter = DetailsPresenter(view: self, source: NetworkAdapter.instance)
        presenter.start()
        presenter.getRepos(text: user)
        presenter.getFollowers(text: user)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    deinit {
        presenter.stop()
    }

}

extension DetailVC {
    private func layout() {
        view.addSubview(selectedImage)
        view.addSubview(usernameLabel)
        view.addSubview(stackView)
        view.addSubview(nav)
        nav.addSubview(backBtn)
        nav.addSubview(navLabel)
        // Activating all Navigation UI with `activate`
        NSLayoutConstraint.activate([
            nav.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            nav.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            nav.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            nav.heightAnchor.constraint(equalToConstant: 52),
            
            backBtn.centerYAnchor.constraint(equalTo: nav.centerYAnchor),
            backBtn.leadingAnchor.constraint(equalTo: nav.leadingAnchor, constant: 16),
            backBtn.heightAnchor.constraint(equalToConstant: 30),
            backBtn.widthAnchor.constraint(equalToConstant: 30),
            
            navLabel.centerYAnchor.constraint(equalTo: nav.centerYAnchor),
            navLabel.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 10),
            navLabel.heightAnchor.constraint(equalToConstant: 30)
            ])

        
        // Seperately constraints this intentionally. Could do both. LOL
        selectedImage.topAnchor.constraint(equalTo: nav.topAnchor, constant: 0).isActive = true
//        selectedImage.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: 8).isActive = true
        selectedImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        selectedImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        usernameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -8).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: selectedImage.bottomAnchor, constant: 16).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        
    }
    
    private func logic() {
        backBtn.addTarget(self, action: #selector(popVc), for: .touchUpInside)
        usernameLabel.text = user
    }
    
    @objc func popVc() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Views
extension DetailVC: DetailsContract.View {
    func showRepos(val: [Repos]) {
        DispatchQueue.main.async {
            self.reposLabel.text = " \(self.user) has \(val.count) public repositories"
        }
    }
    
    func showFollowers(val: [Followers]) {
        DispatchQueue.main.async {
            self.followersLabel.text = "\(val.count) people follows \(self.user)"
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error Occured", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
