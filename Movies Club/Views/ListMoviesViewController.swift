//
//  ListMoviesViewController.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit
import ProgressHUD

class ListMoviesViewController: UIViewController {
    
    // MARK: - Properties
    private let appearance = UINavigationBarAppearance()
    var internetConnectivity: ConnectivityManager?
    var movies : [Movie] = []
    private var currentPage = 1
    private var isFetchingMovies = false

    
    // MARK: - Outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var MovieTableView: UITableView!
    @IBOutlet weak var noInternetView: UIView!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        registerCell()
        fetchData()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        showNoInternetView()
    }
    
    // MARK: - Data fetching function
    private func fetchData(){
        spinner.startAnimating()
        isFetchingMovies = true
        NetworkService.shared.fetchAllMovies(page: currentPage) { [weak self] (result) in
            switch result {
            case .success(let movies):
                self?.spinner.stopAnimating()
                self?.movies.append(contentsOf: movies.results)
                self?.MovieTableView.reloadData()
                self?.currentPage += 1
                self?.isFetchingMovies = false
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.failed(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Register tableview Cell function
    private func registerCell() {
        MovieTableView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellReuseIdentifier: MovieCell.identifier)
    }
    
    // MARK: - NavigationBar SetUp function
    private func setupNavigationBar() {
        title = "Movie List"
        navigationController?.navigationBar.prefersLargeTitles = true
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named: "Background")
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.standardAppearance = appearance
    }
    // MARK: - Check Internet function
    private func showNoInternetView(){
        internetConnectivity = ConnectivityManager.connectivityInstance
        if internetConnectivity?.isConnectedToInternet() == true {
            noInternetView.isHidden = true
        }else {
            noInternetView.isHidden = false
        }
    }
    
    // MARK: - Buttons Action
    @IBAction func refreshBtn(_ sender: Any) {
        if internetConnectivity?.isConnectedToInternet() == true {
            noInternetView.isHidden = true
        }else {
            noInternetView.isHidden = false
        }
        fetchData()
    }
    
}

// MARK: - UITableViewDataSource
extension ListMoviesViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieTableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as! MovieCell
        cell.setup(movie: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Utilities.navigateToDetailsScreen(viewController: self, movieID: movies[indexPath.row].id ?? 0)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //set the initial state of the cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        //UIView animated method to change the final state of the cell
        UIView.animate(withDuration: 1.0){
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 200
   }
}

// MARK: - UITableViewDataSourcePrefetching
extension ListMoviesViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for index in indexPaths {
            if index.row >= movies.count - 3  && !isFetchingMovies{
                fetchData()
                break
            }
        }
    }
    
    
}

