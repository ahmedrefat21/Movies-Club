//
//  MovieDetailsViewController.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit

import UIKit
import ProgressHUD
import Cosmos

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var movie : MovieDetail!
    var movieID : Int = 0
    var genres: [Genre] = []
    private let appearance = UINavigationBarAppearance()
    var internetConnectivity: ConnectivityManager?
    
    // MARK: - Outlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieTotalRating: UILabel!
    @IBOutlet weak var movieRatinginStars: CosmosView!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var favoriteBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupNavigationBar()
        fetchData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkFavorite()
    }
    
    // MARK: - Data fetching function
    private func fetchData(){
        spinner.startAnimating()
        NetworkService.shared.fetchMovieDetails(id: movieID) { [weak self] (result) in
            switch result {
            case .success(let movies):
                self?.spinner.stopAnimating()
                self?.movie = movies
                self?.populateView()
                self?.genresCollectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.failed(error.localizedDescription)
            }
        }
    }
    
    // MARK: - NavigationBar SetUp function
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named: "Background")
        navigationItem.standardAppearance = appearance
    }
    
    // MARK: - Register Collectionview Cell function
    private func registerCell() {
        genresCollectionView.register(UINib(nibName: GenreCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
    }
    
    // MARK: - UI Setup function
    private func populateView (){
        posterImageView.kf.setImage(with: URL(string: Route.imageBaseUrl + (movie.posterPath ?? "")))
        movieImageView.kf.setImage(with: URL(string: Route.imageBaseUrl + (movie.backdropPath ?? "")))
        movieTitleLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        movieReleaseDateLabel.text = Utilities.formatDateString(movie.releaseDate ?? "")
        movieTotalRating.text = String(format: "%.1f", movie.voteAverage ?? 0)
        movieRatinginStars.rating = Double((movie.voteAverage ?? 0) / 2)
        genres = movie.genres ?? []
    }
    
    
    // MARK: - Check Favourie Item functions
    private func checkFavorite() {
        let isFav = DatabaseManager.sharedMovieDB.isFavorite(movieId: movieID)
        if isFav {
            self.favoriteBtnOutlet.image = UIImage(systemName: Constants.fillHeart)
        } else {
            self.favoriteBtnOutlet.image = UIImage(systemName: Constants.heart)
        }
    }
    
    // MARK: - Add Item to Database function
    private func addMovie(){
        let localMovie = LocalMovie(id: movie.id ?? 0, title: movie.originalTitle ?? "", rating: movie.voteAverage ?? 0.0, releaseDate: movie.releaseDate ?? "", image: movie.posterPath ?? "")
        DatabaseManager.sharedMovieDB.insertMovie(movie: localMovie)
        self.favoriteBtnOutlet.image = UIImage(systemName: Constants.fillHeart)
        ProgressHUD.succeed("Movie has been added to Favourite.", delay: 0.7)

        
    }
    // MARK: - Delete Item to Database function
    private func deleteMovie(){
        DatabaseManager.sharedMovieDB.delete(id:  movie.id ?? 0)
        self.favoriteBtnOutlet.image = UIImage(systemName: Constants.heart)
        ProgressHUD.failed("Movie has been deleted from Favourite.")

        
    }
    
    // MARK: - Buttons Action
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func favouriteBtn(_ sender: Any) {
        if favoriteBtnOutlet.image == UIImage(systemName: Constants.heart) {
            addMovie()
        } else {
            deleteMovie()
        }
    }

}
    

// MARK: - UICollectionViewDataSource
extension MovieDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genresCollectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        cell.gernes.text = genres[indexPath.row].name
        return cell
    }
    
}


