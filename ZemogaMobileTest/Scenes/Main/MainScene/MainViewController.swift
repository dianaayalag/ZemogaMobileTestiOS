//
//  MainViewController.swift
//  Zemoga Mobile Test iOS
//
//  Created by Diana Ayala on 5/18/22.
//

import UIKit

protocol MainViewControllerProtocol: NSObjectProtocol {
    func configureAdapters()
    func appearView()
    func setUpRefreshView()
    func setUpView()
    func showLoading(_ show: Bool)
    func presentDetailVC()
    func deleteAllPostsFromDataSource()
    func deleteSinglePost(_ post: Post)
    func didFilterWithResult(_ dataSource: [Any])
    func didSelectPost(_ post: Post)
    func reloadTableWithData(_ dataSource: [Any])
    func setFilterAdapterDataSource(_ dataSource: [Any])
    func showAllPostsDeletedAlert()
    func showCouldntDeletePostAlert()
    func showCouldntDeletePostsAlert()
    func showDeleteAlert(deleteActionHandler: @escaping ActionHandler)
    func showPostDeletedAlert()
}

class MainViewController: UIViewController {
    
    // MARK: User Interface oulets

    @IBOutlet weak var favoritesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var postsTableView: UITableView!
    
    private var currentPost: Post?
    
    private var allowRefreshing = true
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Adapters, presenters and routers

    lazy private var mainAdapter: MainAdapterProtocol = MainAdapter(mainVC: self)
    lazy private var filterAdapter: PostsFilterAdapterProtocol = PostsFilterAdapter(mainVC: self)
    lazy private var presenter: MainPresenterProtocol = MainPresenter(controller: self)
    lazy private var router: MainRouterProtocol = MainRouter(mainVC: self)
    
    // MARK: Controller lifecycle events
    
    override func viewDidAppear(_ animated: Bool) {
        self.presenter.didAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.didLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter.willAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.presenter.prepareForSegue(segue, post: currentPost)
    }
    
    // MARK: Other events
    
    func addRightItems() {
        let deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = ZMTStyleKit.ZMTColors.officialDarkBlue
        deleteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        deleteButton.addTarget(self, action: #selector(self.deleteAll), for: .touchUpInside)
        let deleteItem = UIBarButtonItem(customView: deleteButton)
        navigationItem.setRightBarButtonItems([deleteItem], animated: true)
    }
    
    func showGenericAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController {
    
    // MARK: UI Gestures

    @objc func pullToRefresh() {
        self.presenter.pullToRefresh(shouldRefresh: allowRefreshing)
    }
    
    @objc func deleteAll() {
        self.presenter.deleteAll()
    }
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        self.allowRefreshing = sender.selectedSegmentIndex == 0
        self.filterAdapter.filterByFavorites(favorites: !(sender.selectedSegmentIndex == 0))
    }
}

extension MainViewController: MainViewControllerProtocol {
    
    // MARK: View & configuration events
    
    func configureAdapters() {
        self.mainAdapter.setTableView(self.postsTableView)
    }
    
    func appearView() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUpRefreshView() {
        self.postsTableView.addSubview(self.refreshControl)
    }
    
    func setUpView() {
        favoritesSegmentedControl.setAppearanceWithColor(ZMTStyleKit.ZMTColors.officialDarkBlue)
        favoritesSegmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        self.addRightItems()
    }
    
    func showLoading(_ show: Bool) {
        show ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
    }
    
    // MARK: Navigation events
    
    func presentDetailVC() {
        self.performSegue(withIdentifier: "DetailViewController", sender: nil)
    }
    
    // MARK: Table related events
    
    func deleteAllPostsFromDataSource() {
        self.reloadTableWithData([])
    }
    
    func deleteSinglePost(_ post: Post) {
        self.filterAdapter.deletePost(post)
        self.presenter.deleteSinglePost(post)
    }
    
    func didFilterWithResult(_ dataSource: [Any]) {
        self.reloadTableWithData(dataSource)
    }
    
    func didSelectPost(_ post: Post) {
        currentPost = post
        self.router.navigateToDetailForPost(post)
    }
    
    func reloadTableWithData(_ dataSource: [Any]) {
        self.mainAdapter.dataSource = dataSource
        self.postsTableView.reloadData()
    }
    
    func setFilterAdapterDataSource(_ dataSource: [Any]) {
        self.filterAdapter.dataSource = dataSource as? [Post] ?? []
    }
    
    // MARK: Alert events
    
    func showAllPostsDeletedAlert() {
        self.showGenericAlert(title: "Deleted", message: "All posts successfully deleted")
    }
    
    func showCouldntDeletePostAlert() {
        self.showGenericAlert(title: "Error", message: "Post couldn't be deleted, try again")
    }
    
    func showCouldntDeletePostsAlert() {
        self.showGenericAlert(title: "Error", message: "Posts couldn't be deleted, try again")
    }
    
    func showDeleteAlert(deleteActionHandler: @escaping ActionHandler) {
        let alert = UIAlertController(title: "Delete", message: "Do you really want to delete all posts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteActionHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPostDeletedAlert() {
        self.showGenericAlert(title: "Deleted", message: "Post successfully deleted")
    }
}
