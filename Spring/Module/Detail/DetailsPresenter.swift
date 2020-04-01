//
//  DetailsPresenter.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

class DetailsPresenter: DetailsContract.Presenter {

    private var view: DetailsContract.View?
    private var source: DataSource!
    
    init(view: DetailsContract.View, source: DataSource) {
        self.source = source
        self.view = view
    }

    func getRepos(text: String) {
        source.getRepos(text: text) {[weak self] (result) in
            switch result {
                
            case .success(let repos):
                guard let self = self else  {return}
//                self.repos.append(contentsOf: suc.items)
                self.view?.showRepos(val: repos)
            case .failure(let err):
                guard let self = self else {return}
                self.view?.showError(message: err.localizedDescription)
            }
        }
    }
    
    func getFollowers(text: String) {
        source.getFollowers(text: text) {[weak self] (result) in
            switch result {
                
            case .success(let followers):
                guard let self = self else  {return}
//                self.followers.append(contentsOf: suc)
                self.view?.showFollowers(val: followers)
            case .failure(let err):
                guard let self = self else {return}
                self.view?.showError(message: err.localizedDescription)
            }
        }
    }
    
    internal func resetValues() {
        
    }
    
    func start() {
        
    }
    
    func stop() {
        resetValues()
    }
}
