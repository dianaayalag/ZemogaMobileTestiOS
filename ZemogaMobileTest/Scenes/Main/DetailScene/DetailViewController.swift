//
//  DetailViewController.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import UIKit

protocol DetailViewControllerProtocol: NSObjectProtocol {
    func configureAdapters()
    func disappearView()
    func showLoading(_ show: Bool)
    func displayUser(_ user: User)
    func displayPostInfo(_ post: Post?)
    func setUpView()
    func reloadTableWithData(_ dataSource: [Any])
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.didLoad(post: post)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presenter.willDisappear()
    }
    
    func addRightItems(image: String) {
        let favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(UIImage(systemName: image), for: .normal)
        favoriteButton.tintColor = ZMTStyleKit.ZMTColors.officialDarkBlue
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        let favoriteItem = UIBarButtonItem(customView: favoriteButton)
        navigationItem.setRightBarButton(favoriteItem, animated: true)
    }
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    lazy private var detailAdapter: DetailAdapterProtocol = DetailAdapter(detailVC: self)
    lazy private var presenter: DetailPresenterProtocol = DetailPresenter(controller: self)
    
}

extension DetailViewController {

    @objc func pullToRefresh() {
        self.presenter.pullToRefresh(post: post)
    }
    
    @objc func toggleFavorite() {
        post?.toggleFavorite()
        let buttonImage = post?.favorite ?? false ? "star.fill" : "star"
        self.addRightItems(image: buttonImage)
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    
    func configureAdapters() {
        self.detailAdapter.setTableView(self.commentsTableView)
    }
    
    func showLoading(_ show: Bool) {
        show ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
    }
    
    func reloadTableWithData(_ dataSource: [Any]) {
        self.detailAdapter.dataSource = dataSource
        self.commentsTableView.reloadData()
    }
    
    func displayPostInfo(_ post: Post?) {
        titleLabel.text = post?.title
        descriptionLabel.text = post?.body
    }
    
    func displayUser(_ user: User) {
        userNameLabel.text = user.name
        userEmailLabel.text = user.email
        userPhoneLabel.text = user.phone
        userWebsiteLabel.text = user.website
    }
    
    func setUpView() {
        let buttonImage = post?.favorite ?? false ? "star.fill" : "star"
        self.addRightItems(image: buttonImage)
        self.navigationController?.navigationBar.tintColor = ZMTStyleKit.ZMTColors.officialDarkBlue
    }
    
    func disappearView() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
