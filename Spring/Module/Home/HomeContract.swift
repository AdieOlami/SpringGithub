//
//  HomeContract.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

struct HomeContract {
    typealias View = _HomeView
    typealias Presenter = _HomePresenter
}

protocol _HomeView: BaseView {
    func showImages(users: [Items])
    func showError(message: String)
}

protocol _HomePresenter: BasePresenter {
    func getImages(text: String)
    func resetValues()
}
