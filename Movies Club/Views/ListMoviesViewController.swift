//
//  ListMoviesViewController.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit
import ProgressHUD

class ListMoviesViewController: UIViewController {

    @IBOutlet weak var MovieTableView: UITableView!
    private let appearance = UINavigationBarAppearance()
    var movies : [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        registerCell()
        ProgressHUD.show()
    }
    override func viewDidAppear(_ animated: Bool) {
        setupNavigationBar()
        fetchData()
        
    }
    
    private func fetchData(){
        NetworkService.shared.fetchAllMovies { [weak self] (result) in
            switch result {
            case .success(let movies):
                ProgressHUD.dismiss()
                self?.movies = movies.results
                self?.MovieTableView.reloadData()
            case .failure(let error):
                print("error")
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
    private func registerCell() {
        MovieTableView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellReuseIdentifier: MovieCell.identifier)
    }
    
    private func setupNavigationBar() {
        title = "Movie List"
        navigationController?.navigationBar.prefersLargeTitles = true
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named: "Background")
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.standardAppearance = appearance
    }
}
extension ListMoviesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieTableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as! MovieCell
        cell.setup(movie: movies[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 200
   }
}

