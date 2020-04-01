//
//  DetailsPresenter.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {

    private var presenter: HomeContract.Presenter!
    var userArray: [Items] = [Items]()
        
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var searchBar = UISearchBar()
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var numberOfCellInArow: CGFloat = 2.0
    fileprivate var cellPadding:CGFloat = 10.0
    fileprivate var isLoading = false
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    func navigationBarSetUp() {
        searchBar.placeholder = "Search Github Users"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(view: self, source: NetworkAdapter.instance)
        presenter.start()
        self.collectionView.dataSource = self

        collectionView.delegate = self
        self.navigationBarSetUp()
        hideKeyboardWhenTappedAround()
    }
    
    
    deinit {
        presenter.stop()
    }
    
    private func fetchImages() {
        presenter.getImages(text: searchBar.text ?? "")
        guard let text = searchBar.text else {return}
    }
}

//MARK: - SearchBar Delegate
extension HomeVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //Reset old data first befor new search Results
        presenter.resetValues()
        userArray.removeAll()
        guard let text = searchBar.text?.components(separatedBy: .whitespaces).joined(),
            text.count != 0  else {
                loadingLbl.text = "Please type keyword to search result."
                return
        }
        //Requesting new keyword
        
        self.fetchImages()
        loadingLbl.text = "Searching User..."
    }
}

//MARK: - Collection View Delegate
extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is PhotoCell {
            DispatchQueue.main.async {
                if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    cell.cellImage.kf.indicatorType = .activity
                    cell.cellImage.kf.setImage(with: self.userArray[indexPath.row].getImagePath())
                    cell.username.text = self.userArray[indexPath.row].login
                }
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailVC()
        controller.user = self.userArray[indexPath.row].login
        controller.navLabel.text = self.userArray[indexPath.row].login
        controller.selectedImage.kf.indicatorType = .activity
        controller.selectedImage.kf.setImage(with: self.userArray[indexPath.row].getImagePath())
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        guard self.userArray.count != 0 else {
            return cell
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width;
        let itemWidth = collectionWidth / numberOfCellInArow - cellPadding;
        
        return CGSize(width: itemWidth, height: itemWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
}

//MARK: - Scrollview Delegate
extension HomeVC: UIScrollViewDelegate {
    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
                //locading new data
                if(!isLoading){
                    self.addLoader()
                    self.fetchImages()
                    isLoading = true
                }
            }
        }
    }
    //MARK: Loader at bottom
    fileprivate func addLoader() {
        self.activityIndicator.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.collectionViewBottomConstraint.constant = 40
        }, completion: nil)
    }

    fileprivate func removeLoader() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.activityIndicator.isHidden = true
            self.collectionViewBottomConstraint.constant = 0
        }, completion: nil)
    }
    
    fileprivate func loader() {
        self.isLoading = false
        self.removeLoader()
        self.loadingLbl.text = ""
    }
}

// MARK: Views
extension HomeVC: HomeContract.View {
    // This passes the images from the presenter to determine the view
    func showImages(users: [Items]) {
        self.userArray.removeAll()
        DispatchQueue.main.async {
            self.userArray.append(contentsOf: users)
            self.loader()
            self.collectionView.reloadData()
        }
        
    }
    
    func showError(message: String) {
        loader()
        let alert = UIAlertController(title: "Error Occured", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
