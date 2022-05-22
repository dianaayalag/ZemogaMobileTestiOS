//
//  DetailViewController.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/19/22.
//

import UIKit

protocol DetailViewControllerProtocol: NSObjectProtocol {
    func configureAdapters()
    func appearView()
    func setUpView()
    func showLoading(_ show: Bool)
    func reloadTableWithData(_ dataSource: [Any])
    func displayPostInfo(_ post: Post?)
    func displayUser(_ user: User)
}

class DetailViewController: UIViewController {
    
    // MARK: User Interface oulets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    var post: Post?
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Adapters, presenters and routers
    
    lazy private var detailAdapter: DetailAdapterProtocol = DetailAdapter(detailVC: self)
    lazy private var presenter: DetailPresenterProtocol = DetailPresenter(controller: self)
    
    // MARK: Controller lifecycle events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.didLoad(post: post)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter.willAppear()
    }
    
    // MARK: Other events
    
    func addRightItems(image: String) {
        let favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(UIImage(systemName: image), for: .normal)
        favoriteButton.tintColor = ZMTStyleKit.ZMTColors.officialDarkBlue
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        let favoriteItem = UIBarButtonItem(customView: favoriteButton)
        navigationItem.setRightBarButton(favoriteItem, animated: true)
    }
}

extension DetailViewController {
    
    // MARK: UI Gestures

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
    
    // MARK: View & configuration events
    
    func configureAdapters() {
        self.detailAdapter.setTableView(self.commentsTableView)
    }
    
    func appearView() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setUpView() {
        let buttonImage = post?.favorite ?? false ? "star.fill" : "star"
        self.addRightItems(image: buttonImage)
        self.navigationController?.navigationBar.tintColor = ZMTStyleKit.ZMTColors.officialDarkBlue
    }
    
    func showLoading(_ show: Bool) {
        show ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
    }
    
    // MARK: Table related events
    
    func reloadTableWithData(_ dataSource: [Any]) {
        self.detailAdapter.dataSource = dataSource
        self.commentsTableView.reloadData()
    }
    
    // MARK: Display events
    
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
}
