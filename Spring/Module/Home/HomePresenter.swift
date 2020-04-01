//
//  HomePresenter.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

class HomePresenter: HomeContract.Presenter {
    
    private var view: HomeContract.View?
    private var source: DataSource!
    
    fileprivate var pageCount = 0
    fileprivate var users: [Items] = [Items]()
    
    init(view: HomeContract.View, source: DataSource) {
        self.source = source
        self.view = view
    }

    func getImages(text: String) {
        source.getUsers(text: text) {[weak self] (result) in
            switch result {
                
            case .success(let suc):
                guard let self = self else  {return}
                self.users.append(contentsOf: suc.items)
                self.view?.showImages(users: self.users)
            case .failure(let err):
                guard let self = self else {return}
                self.view?.showError(message: err.localizedDescription)
            }
        }
    }
    
    func resetValues() {
        pageCount = 0
        users.removeAll()
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
}
