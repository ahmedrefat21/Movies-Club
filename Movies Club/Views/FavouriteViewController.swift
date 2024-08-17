//
//  FavouriteViewController.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit
import ProgressHUD

class FavouriteViewController: UIViewController {
    
    // MARK: - Properties
    private let appearance = UINavigationBarAppearance()
    var internetConnectivity: ConnectivityManager?
    var favouriteMovies: [LocalMovie] = []

    // MARK: - Outlets
    @IBOutlet weak var FavouriteTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        registerCell()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        setupNavigationBar()
        checkIfThereAreFavoriteProducts(allMoviesList: favouriteMovies)
    }
    
    // MARK: - Data fetching functions
    private func fetchData(){
        spinner.startAnimating()
        self.favouriteMovies = DatabaseManager.sharedMovieDB.fetchAllMovies() ?? []
        spinner.stopAnimating()
        self.FavouriteTableView.reloadData()
    }

    // MARK: - Register tableview Cell function
    private func registerCell() {
        FavouriteTableView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellReuseIdentifier: MovieCell.identifier)
    }
    
    // MARK: - NavigationBar SetUp function
    private func setupNavigationBar() {
        title = "Favourite Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named: "Background")
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.standardAppearance = appearance
    }
    
    // MARK: - Check EmptyList function
    private func checkIfThereAreFavoriteProducts(allMoviesList:[LocalMovie]){
        FavouriteTableView.isHidden = allMoviesList.isEmpty
    }

}

// MARK: - UITableViewDataSource
extension FavouriteViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FavouriteTableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as! MovieCell
        cell.setupFavouriteList(movie: favouriteMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        internetConnectivity = ConnectivityManager.connectivityInstance
        if internetConnectivity?.isConnectedToInternet() == true {
            Utilities.navigateToDetailsScreen(viewController: self, movieID: favouriteMovies[indexPath.row].id)
        }else {
            ProgressHUD.failed("Try Connect to WiFi")
        }
        
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
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            
            let alert : UIAlertController = UIAlertController(title: "Confirm to delete", message: "Are you sure you want to delete this Movie?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                
                DatabaseManager.sharedMovieDB.delete(id:self.favouriteMovies[indexPath.row].id)
                self.favouriteMovies.remove(at: indexPath.row)
                self.FavouriteTableView.reloadData()
                ProgressHUD.failed("Movie has been deleted from Favourite.")
                self.checkIfThereAreFavoriteProducts(allMoviesList: self.favouriteMovies)

                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
            self.present(alert, animated: true)
        }
    }
}
