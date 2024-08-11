//
//  FavouriteViewController.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit
import ProgressHUD

class FavouriteViewController: UIViewController {

    @IBOutlet weak var FavouriteTableView: UITableView!
    private let appearance = UINavigationBarAppearance()
    var favouriteMovies: [LocalMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        registerCell()
        ProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        setupNavigationBar()
    }
    
    private func fetchData(){
        self.favouriteMovies = DatabaseManager.sharedMovieDB.fetchAllMovies() ?? []
        ProgressHUD.dismiss()
        self.FavouriteTableView.reloadData()
    }

    
    private func registerCell() {
        FavouriteTableView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellReuseIdentifier: MovieCell.identifier)
    }
    
    private func setupNavigationBar() {
        title = "Favourite Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named: "Background")
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.standardAppearance = appearance
    }

}

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
        let controller = MovieDetailsViewController.instantiate()
        controller.movieID = favouriteMovies[indexPath.row].id
        navigationController?.pushViewController(controller, animated: true)
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
