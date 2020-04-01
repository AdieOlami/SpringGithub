//
//  DetailsContact.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

struct DetailsContract {
    typealias View = _DetailsView
    typealias Presenter = _DetailsPresenter
}

protocol _DetailsView: BaseView {
    func showRepos(val: [Repos])
    func showFollowers(val: [Followers])
    func showError(message: String)
}

protocol _DetailsPresenter: BasePresenter {
    func getRepos(text: String)
    func getFollowers(text: String)
    func resetValues()
}
